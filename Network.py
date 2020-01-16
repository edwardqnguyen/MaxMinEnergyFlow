import Bus
import copy
import cvxpy as cp
import numpy as np
import math

class Network:
    def __init__(self, name, dataInput):
        self.name = name
        self.buses = {}
        self.busNames = [] # explicit list since buses are numbered
        self.root = None
        self.generatorNames = []
        self.generatorMax = {}

        self.busNames = dataInput["bus_name"]

        # Establishing names and instantiating buses
        for nameIndex in range(len(self.busNames)):
            name = self.busNames[nameIndex]
            self.buses[name] = Bus.Bus(name)
            self.buses[name].load = dataInput["bus"][nameIndex][2]

        self.root = self.buses[self.busNames[0]] # TODO: don't hardcode root.

        # Establishing connections
        for branchData in dataInput["branch"]:
            b1 = int(branchData[0] - 1) # 0 - indexed
            b2 = int(branchData[1] - 1)
            capacity = branchData[5]

            if b1 < 0 or b1 >= len(self.busNames):
                print(b1 + " out of bus numbered range")
            elif b2 < 0 or b2 >= len(self.busNames):
                print(b2 + " out of bus numbered range")
            elif b1 == b2:
                print(b1 + " should not be connected to itself")
            else:
                orig_bus_name = self.busNames[b1]
                connected_bus_name = self.busNames[b2]
                orig_bus = self.buses[orig_bus_name]
                connected_bus = self.buses[connected_bus_name]
                orig_bus.connections[connected_bus_name] = (0, capacity)
                connected_bus.connections[orig_bus_name] = (0, capacity)

        # Establish generator costs
        for genIndex in range(len(dataInput["gen"])):
            # print("generator found")
            index = int(dataInput["gen"][genIndex][0] - 1)
            genMax = float(dataInput["gen"][genIndex][8])
            genName = self.busNames[index]
            self.generatorNames.append(genName)
            self.generatorMax[genName] = genMax
            generator = self.buses[genName]
            genCost = dataInput["gencost"]
            generator.injectionCost = (genCost[genIndex][4], genCost[genIndex][5], genCost[genIndex][6]) # TODO: Remove hardcoded polynomial cost.


    """
    returns names of buses
    """
    def getBusNames(self):
        return self.busNames

    """
    returns bus associated with a name
    """
    def getBus(self, name):
        return self.buses[name]
    
    """
    Checks graph for cycle. Low priority
    """
    def containsCycle(self):
        vertices = self.buses.keys()
        if len(vertices) == 0:
            return False
        root = vertices[0]
        return False

    """
    points: list of tuples of x,y points
    returns: tuple (m, b) with slope and intercept
    """
    def linearReg(self, points):
        x_list = [a[0] for a in points]
        y_list = [a[1] for a in points]

        x_ave = sum(x_list)/len(x_list)
        y_ave = sum(y_list)/len(y_list)

        bottom = sum([(x_list[i]-x_ave)**2 for i in range(len(points))])
        top = sum([(x_list[i]-x_ave)*(y_list[i]-y_ave) for i in range(len(points))])

        if bottom == 0:
            bottom = .001

        slope = top/bottom
        intercept = y_ave - slope*x_ave
        return slope, intercept

    """
    Cvxpy expression for the sum of bid functions
    """
    def getBidSumExp(self, nodeNames, requestedVarExp, bidFunctions):
        linearList = [bidFunctions[x][1] for x in nodeNames]
        linearNumpyArray = np.asarray(linearList)
        linearSumCVXPYExp = linearNumpyArray * requestedVarExp

        quadList = [.5 * bidFunctions[x][0] for x in nodeNames]
        quadNumpyArray = np.asarray(quadList)
        quadSumCVXPYExp = cp.square(requestedVarExp) * quadNumpyArray

        return linearSumCVXPYExp + quadSumCVXPYExp

    def getInjectionCostExp(self, injectionVar, generatorTuple):
        return generatorTuple[0]*cp.square(injectionVar)+generatorTuple[1]*injectionVar


    def getChildNodeNames(self, currentNode, parentNode):
        childNodeNames = copy.deepcopy(currentNode.connections.keys())
        if parentNode is not None:
            childNodeNames.remove(parentNode.name)
        return childNodeNames  

    def getGenerationMax(self, name):
        if name not in self.generatorNames:
            return 0
        else:
            return self.generatorMax[name]

    def forwardSweep(self, currentNode, parentNode, bidFunctions, minFlow, maxFlow):
        childNodeNames = self.getChildNodeNames(currentNode, parentNode)
        minFlowsList = []
        maxFlowsList = []

        if len(childNodeNames) == 0: #leaf node has undefined elasticity. p.u. price set to 1.
            load = currentNode.load
            minLoad = load - self.getGenerationMax(currentNode.name)
            maxLoad = load
            points = [(0,.999*load),(1,load),(2,1.001*load)]
            bidFunctions[currentNode.name] = self.linearReg(points)
            capacity = parentNode.connections[currentNode.name] if parentNode is not None else (0, 0)
            minFlow[currentNode.name] = max(capacity[0], minLoad)
            maxFlow[currentNode.name] = min(capacity[1], maxLoad)
            return

        for name in childNodeNames:
            if name not in bidFunctions.keys():
                self.forwardSweep(self.buses[name], currentNode, bidFunctions, minFlow, maxFlow)

        minFlowsList = [minFlow[name] for name in childNodeNames]
        maxFlowsList = [maxFlow[name] for name in childNodeNames]
        minSumLoad = max(sum(minFlowsList) - self.getGenerationMax(currentNode.name) + currentNode.load, 0)
        maxSumLoad = sum(maxFlowsList) + currentNode.load

        if minSumLoad == maxSumLoad: # No Wiggle Room
            capacity = parentNode.connections[currentNode.name] if parentNode is not None else (0, 0)
            minFlow[currentNode.name] = max(capacity[0], minSumLoad)
            maxFlow[currentNode.name] = min(capacity[1], maxSumLoad)
            load = minSumLoad
            points = [(0,.999*load),(1,load),(2,1.001*load)]
            bidFunctions[currentNode.name] = self.linearReg(points)
            return

        # Formulate convex optimization problem and solve. 
        injection = cp.Variable()
        parentFlow = cp.Parameter()
        requested = cp.Variable(len(childNodeNames))
        objective = self.getBidSumExp(childNodeNames, requested, bidFunctions)
        flowConstraintExp = None
        constraints = []    
        points = []

        if currentNode.name in self.generatorNames:
            objective = objective + self.getInjectionCostExp(injection, currentNode.injectionCost)
            flowConstraintExp = cp.sum(requested) - injection + currentNode.load
        else:
            flowConstraintExp = cp.sum(requested) + currentNode.load

        testParentInFlow = (minSumLoad + maxSumLoad)/2.0 + currentNode.load
        if parentNode is not None: # Not the slack bus
            testParentInFlow = min(parentNode.connections[currentNode.name][1]/2.0, testParentInFlow)
        testFlows = [.999, 1, 1.001]

        for factor in testFlows:
            constraints = []
            #print(flowConstraintExp == factor*testParentInFlow)
            constraints.append(flowConstraintExp == factor*testParentInFlow)
            constraints.append(requested >= np.asarray(minFlowsList))
            constraints.append(requested <= np.asarray(maxFlowsList))
            if currentNode.name in self.generatorNames:
                constraints.append(0 <= injection)
                constraints.append(self.generatorMax[currentNode.name] >= injection)
            problem = cp.Problem(cp.Minimize(objective), constraints)
            #print(cp.Minimize(objective))
            problem.solve()
            lam = problem.constraints[0].dual_value # dual value can be negative due to constraint definition, but prices must be positive
            if lam < 0: # Other if statement should be first, but having this first causes fail fast when algorithm fails.
                lam = - lam
            if lam is None:
                lam = 0
            
            points.append((lam, factor*testParentInFlow))

        newBid = self.linearReg(points)
        if newBid[0] < 0: # Flow heading other direction
            newBid = (-newBid[0], newBid[1])

        bidFunctions[currentNode.name] = newBid
        capacity = parentNode.connections[currentNode.name] if parentNode is not None else (0, 0)

        minFlow[currentNode.name] = max(capacity[0], minSumLoad)
        maxFlow[currentNode.name] = min(capacity[1], maxSumLoad)

        return

    def backwardSweep(self, currentNode, parentNode, bidFunctions, price, amount, minFlow, maxFlow):
        childNodeNames = self.getChildNodeNames(currentNode, parentNode)
        minFlowsList = []
        maxFlowsList = []

        if len(childNodeNames) == 0: #leaf node consumes all power.
            if currentNode.name in self.generatorNames:
                print("Generator "+str(currentNode.name)+" produces: "+str(currentNode.load - amount)+"W")
            return

        injection = cp.Variable()
        parentFlow = cp.Parameter()
        parentFlow.value = amount
        requested = cp.Variable(len(childNodeNames))
        objective = self.getBidSumExp(childNodeNames, requested, bidFunctions) - price*parentFlow
        constraints = []

        minFlowsList = [minFlow[name] for name in childNodeNames]
        maxFlowsList = [maxFlow[name] for name in childNodeNames]

        if currentNode.name in self.generatorNames:
            objective = objective + self.getInjectionCostExp(injection, currentNode.injectionCost)
            flowConstraintExp = cp.sum(requested) - injection + currentNode.load
        else:
            flowConstraintExp = cp.sum(requested) + currentNode.load

        constraints.append(flowConstraintExp == parentFlow)
        constraints.append(requested >= np.asarray(minFlowsList))
        constraints.append(requested <= np.asarray(maxFlowsList))
        if currentNode.name in self.generatorNames:
            constraints.append(0 <= injection)
            constraints.append(self.generatorMax[currentNode.name] >= injection)
        problem = cp.Problem(cp.Minimize(objective), constraints)
        problem.solve()

        if problem.value >= 10000000: #no solution found
            print(currentNode.name)
            print("$"+str(price) + " per W")
            print("Inflow Amount: "+str(amount))
            print("Load "+str(currentNode.load))
            print(self.getGenerationMax(currentNode.name))
            print(minFlowsList)
            print(maxFlowsList)
            print("SumLoad ",sum(minFlowsList),sum(maxFlowsList))

        if currentNode.name in self.generatorNames:
            print("Generator "+str(currentNode.name)+" produces: "+str(injection.value)+"W")

        lam = problem.constraints[0].dual_value
        if lam < 0: # Other if statement should be first, but having this first causes fail fast when algorithm fails.
                lam = - lam
        if lam is None:
            lam = 0
        flows = requested.value
        flows = flows.tolist()

        for i in range(len(childNodeNames)):
            self.backwardSweep(self.buses[childNodeNames[i]], currentNode, bidFunctions, lam, requested.value[i], minFlow, maxFlow)


        return

    def printNetworkInfo(self):
        for name in self.busNames:
            bus = self.buses[name]
            print("Bus "+name+" info:")
            print("-----------------------")
            print("Load: "+str(bus.load)+"W")
            for con in bus.connections.keys():
                print("Connection: "+con+" capacity: "+str(bus.connections[con]))        

    def distributedEconomicDispatch(self):
        bidFuncs = {}
        minFlow = {}
        maxFlow = {}
        self.forwardSweep(self.root, None, bidFuncs, minFlow, maxFlow)
        self.backwardSweep(self.root, None, bidFuncs, 0, 0, minFlow, maxFlow)

    def testDisconnections(self): #Disconnected buses 18 and 19 in the Flores Example
        bidFuncs = {}
        minFlow = {}
        maxFlow = {}
        self.forwardSweep(self.root, None, bidFuncs, minFlow, maxFlow)
        self.forwardSweep(self.buses[self.busNames[18]], None, bidFuncs, minFlow, maxFlow)
        self.backwardSweep(self.root, None, bidFuncs, 0, 0, minFlow, maxFlow)
        self.backwardSweep(self.buses[self.busNames[18]], None, bidFuncs, 0, 0, minFlow, maxFlow)

    """
    Proportional Load Control
    """
    def setInitialLoads(self, currentNode, parentNode, loads):
        childNodeNames = self.getChildNodeNames(currentNode, parentNode)
        if len(childNodeNames) == 0:
            loads[currentNode.name] = currentNode.load
            return
        for name in childNodeNames:
            if name not in loads.keys():
                self.setInitialLoads(self.buses[name], currentNode, loads)
        sumLoad = sum(loads[name] for name in childNodeNames)
        netLoad = max(0, sumLoad-self.getGenerationMax(currentNode.name)+currentNode.load)
        loads[currentNode.name] = netLoad
        return

    def adjustLoads(self, currentNode, parentNode, loads, injection):
        childNodeNames = self.getChildNodeNames(currentNode, parentNode)
        genCap =injection + self.getGenerationMax(currentNode.name)
        if genCap < loads[currentNode.name]:
            reductionFactor = genCap/loads[currentNode.name]
            currentNode.load = currentNode.load * reductionFactor * .999
        for name in childNodeNames:
            self.adjustLoads(self.buses[name], currentNode, loads, genCap*loads[name]/loads[currentNode.name])
        return

    def testCalculatedResult(self):
        load = {}
        self.setInitialLoads(self.root, None, load)
        self.adjustLoads(self.root, None, load, 0)
        newload = {}
        self.setInitialLoads(self.root, None, newload)
        print(newload.values())
        print(load.values())

    """
    AIMD simulation
    """

    def checkTree(self, currentNode, parentNode, loads, injection):
        childNodeNames = self.getChildNodeNames(currentNode, parentNode)
        genCap =injection + self.getGenerationMax(currentNode.name)
        ret = True
        if genCap < loads[currentNode.name] - .0001: #Error Margin
            return False
        for name in childNodeNames:
            ret = ret and self.checkTree(self.buses[name], currentNode, loads, genCap*loads[name]/loads[currentNode.name])
        return ret

    def multiplicativeDecrease(self, currentNode, parentNode, factor):
        childNodeNames = self.getChildNodeNames(currentNode, parentNode)
        currentNode.load = currentNode.load*factor
        for name in childNodeNames:
            ret = self.multiplicativeDecrease(self.buses[name], currentNode, factor)
        return

    def additiveIncrease(self, currentNode, parentNode, increment):
        childNodeNames = self.getChildNodeNames(currentNode, parentNode)
        currentNode.load = currentNode.load * (1+increment)
        for name in childNodeNames:
            ret = self.additiveIncrease(self.buses[name], currentNode, increment)
        return

    def aimdUpdate(self, currentNode, parentNode, loads, injection):
        childNodeNames = self.getChildNodeNames(currentNode, parentNode)
        genCap = injection + self.getGenerationMax(currentNode.name)
        if genCap < loads[currentNode.name] - .001: #Error Margin
            self.multiplicativeDecrease(currentNode, parentNode, .5)
            return False
        if genCap > loads[currentNode.name] + .01:
            self.additiveIncrease(currentNode, parentNode, .0001)
            return False
        ret = True
        for name in childNodeNames:
            ret = ret and self.aimdUpdate(self.buses[name], currentNode, loads, genCap*loads[name]/loads[currentNode.name])
        return ret

    def testAIMDResult(self):
        load = {}
        self.setInitialLoads(self.root, None, load)
        counter = 0
        ret = False
        while not ret:
            load = {}
            self.setInitialLoads(self.root, None, load)
            equilibrium = self.aimdUpdate(self.root, None, load, 0)
            ret = ret or equilibrium
            counter = counter + 1
            if counter == 300000:
                ret = True
        print(load.values())
            









        

            
                        
            
