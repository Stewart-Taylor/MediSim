class AgentManager

    constructor: (scene, world) ->
        console.log("Agent Manager Module Loaded")
        @agents = []


    update: () ->
        for agent in @agents
            agent.update()


    removeAgent: (removeAgent) ->
        removeAgentIndex = @agents.indexOf(removeAgent)
        @agents.splice(removeAgentIndex, 1)


    addAgent: (town,targetTown, x,y, isGuard) ->
        agent = new Agent(town,targetTown, x,y, isGuard)
        @agents.push agent
        return agent

