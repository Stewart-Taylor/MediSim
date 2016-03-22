class AgentManager

    constructor: (scene, world) ->
        console.log("Agent Manager Module Loaded")
        @agents = []


    update: () ->
        for agent in @agents
            agent.update()


    addAgent: (town,targetTown, x,y, isGuard) ->
        agent = new Agent(town,targetTown, x,y, isGuard)
        @agents.push agent
        return agent
