import Network
from pypower import case24_ieee_rts as testcase

def main():
    x = testcase.case24_ieee_rts()
    print(x)
    network = Network.Network("test", "testNetwork.txt")
    print("No bugs")

if __name__ == "__main__":
    main()