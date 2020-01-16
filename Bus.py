class Bus:
    def __init__(self, name):
        self.name = name
        self.injectionCost = None   # use to store data for injection
        self.load = None            # use to store data about consumption
        self.connections = {}       # name -> (min, max)

    
