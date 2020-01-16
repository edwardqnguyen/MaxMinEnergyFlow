import Network
import FloresCase
import cvxpy as cp
import numpy as np
import random
import matplotlib.pyplot as plt

def main():
    data = FloresCase.caseFlores()
    network = Network.Network("FloresNetwork",data)
    #network.distributedEconomicDispatch()
    #network.testDisconnections()
    network.testCalculatedResult()
    #network.testAIMDResult()
    print("No Runtime Errors")

def cvxpyExample():
    # Generate a random non-trivial linear program.
    m = 15
    n = 10
    np.random.seed(1)
    s0 = np.random.randn(m)
    lamb0 = np.maximum(-s0, 0)
    s0 = np.maximum(s0, 0)
    x0 = np.random.randn(n)
    A = np.random.randn(m, n)
    b = cp.matmul(A,x0) + s0
    c = cp.matmul(-A.T,lamb0)

    # Define and solve the CVXPY problem.
    x = cp.Variable(n)
    prob = cp.Problem(cp.Minimize(cp.matmul(c.T,x)),
                    [cp.matmul(A,x) <= b])
    prob.solve()

    # Print result.
    print("\nThe optimal value is", prob.value)
    print("A solution x is")
    print(x.value)
    print("A dual solution is")
    print(prob.constraints[0].dual_value)

def roll_d6():
    return int(random.random()*6)+1

def dice_test():
    sample_size = 5
    stat_bucket = [0,0,0,0,0,0]
    i = 0
    while i < sample_size:
        temp_bucket = []
        for j in range(len(stat_bucket)):
            temp = []
            for k in range(4):
                temp.append(roll_d6())
            temp.sort()
            stat_val = temp[1] + temp[2] + temp[3]
            temp_bucket.append(stat_val)
        temp_bucket.sort()
        if sum(temp_bucket) >= 70:
            print(temp_bucket)
            for j in range(len(stat_bucket)):
                stat_bucket[j] = stat_bucket[j] + temp_bucket[j]
            i = i+1
    
    for j in range(len(stat_bucket)):
        stat_bucket[j] = stat_bucket[j]/float(sample_size)

    print(stat_bucket)

def graph_method():
    percentages = [1.0, 0.46400371574547133, 1, 0.46400371574547133, 0.4640037157454715, 1.0, 0.4640037157454714,
    0.46400371574547156, 0.46400371574547133,0.4640037157454715,1,0.46400371574547133,0.46400371574547156,
    1.0, 0.2150504950048636, 0.46400371574547145, 0.4640037157454715, 0.4640037157454714, 1.0,
    0.46400371574547156,
    0.4640037157454713,
    0.4640037157454714,
    0.4640037157454715,
    0.46400371574547145,
    0.46400371574547133,
    0.46400371574547145,
    0.4640037157454714,
    0.46400371574547145,
    0.46400371574547145,
    0.46400371574547133,
    0.46400371574547145,
    0.46400371574547145,
    1.0,
    1.0,
    0.4640037157454714,
    1.0,
    0.4640037157454714,
    0.46400371574547133,
    0.46400371574547145,
    1.0,
    0.46400371574547133,
    0.46400371574547133,
    0.4640037157454715,
    0.4640037157454715,
    0.46400371574547145,
    0.46400371574547145]

    plt.plot(percentages, 'ro')
    plt.axis([0,45,0,1.0])
    plt.xlabel("Bus")
    plt.ylabel("Percentage power load served")
    plt.title("Load Served in Feasible Solution")
    plt.show()



if __name__ == "__main__":
    graph_method()