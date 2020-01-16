import Network

def RadialNetworkClear(name, file, epsilon = .001):
    network = Network.Network(name, file)
    bidMap = {}
    forwardSweep(network, bidMap)
    

"""
Forward Sweep code:
    - forwardSweep Main algorithm
    - calculate bid subtask
    - convex optimizer solver
"""
# Main Forward Sweep Method
def forwardSweep(network, bidMap):
    verticeNames = network.getNodeNames()
    if len(verticeNames) == 0:
        return
    rootName = verticeNames[0]
    calculateBid(network, bidMap, rootName, None)
    return rootName # To clear efficiently

# Bid Subtask Method
def calculateBid(network, bidMap, name, parentName):
    currentNode = network.getNode(name)
    connectedNodeNames = currentNode.connections.keys()
    for nodeName in connectedNodeNames:
        if nodeName is not parentName and nodeName not in bidMap.keys():
            calculateBid(network, bidMap, nodeName, name)
    bidMap[name] = forwardSolver(network, bidMap, name, parentName)

# Convex Optimizer Subtask
def forwardSolver(network, bidMap, name, parentName)

"""
Backward Sweep code:
    - 
"""
def backwardSweep(network, bidMap, rootName):
    



if __name__ == "__main__":
    RadialNetworkClear("test","testNetwork.txt")*