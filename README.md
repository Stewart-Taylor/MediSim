MediSim
===================
To watch the action - http://stewart-taylor.github.io/MediSim/

# Introduction

![View of a generated island](http://i.imgur.com/JstcmHp.png)

MediSim is a simulation of a little collection of civilizations that co exist on an island. The idea of this little experiment is that you don't interact with it you just watch and see how the mechanics of the simulation take over allowing the island and civilizations to organically evolve.


# Simulation Details
This section will explain a bit more of what is going on for those that are curious. There is a lot of factors and rules which the civilizations adopt to which allows them to expand.

## The island

![View of the land](http://i.imgur.com/ibjJhZq.png)

As you can see the land is made up of clear distinct green tiles, blue water and some very pointy mountains. The color of each title indicates the yield of the land. The greener the land the better the yield and the darker the tile the worse the yield of the land.

This yield value becomes very important for the civilizations as they build there farms on the land.

There is a slight clustering of land values so high land values will be adjacent to other high land values. Mountain regions and coastal regions receive a penalty to land value.


## The Civilizations
Each unique civilization can be seen by its unique color. The goal of each civilization differs based on an aggression value. Some civilizations will want to expand quickly and attempt to take over the whole island while other civilizations may be content with what they have and simply produce guards to defend its self.

## The Towns
![Image of slightly grown town](http://i.imgur.com/blnqXjU.png)
Towns are the main hubs for each civilization. The big cube is the townhall and is the main hub of the town. This is where units will be produced and what will to be defend to prevent the town from being captured.

Towns will grow and expand organically to allocate make use of the natural resources it has available.  Towns will produce farm to increase food production. When food is in a surplus the population of the town will increase. After a while the population will reach the cap for the townhall so a house will be build. Houses will usually be built on the land with the lowest yield (They can only be built on existing claimed farm land).

Towns will receive gold based on the population it has. Gold can they then be used by towns to either build new houses or to create soldiers or guards.

Civilizations can invade and take over other towns. This happens when a town is attacked and its population drops to zero. It will then change color and become part of that civilization.

### Farmland
The brown squares are farm plots they produce food based on the yield of the land. An amount of the population is required to work on the farm tiles.

### House
Houses are the smaller cubes they will house the population and new ones will have to be built to increase the population more.

## The Units

![Units in battle](http://i.imgur.com/iUj0FTS.png)

Units are created by towns by spending an amount of the accumulated gold. Units can have two purposes. They can either be attackers or they can be a defender. When the unit is created this is determined for them based on the civilizations aggressiveness.


### Attackers
The attackers will seek out the closest town and attack it. While a town is being attacked the population will start to reduce which will also destroy the house for that town. When all the houses are destroyed and the population reaches zero, that town will be captured and join the attackers civilization.

### Defenders
The defenders will stay near the town that produced them. They will wait by there town until an attacker shows up. When the attacker is close enough the defender will go and engage that attacker.




# How to Set up on your machine

First of all make sure you have the following installed

    npm install -g coffee-script
    npm install -g grunt
    npm install -g http-server

Once you have those run

    grunt

you can either keep it on for the watch or cancel it. You also want to run

    http-server
in the static directory

