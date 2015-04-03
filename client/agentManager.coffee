class AgentManager

    constructor: (scene, world) ->
        console.log("Agent Manager Module Loaded")

        @agents = []

        # @player = new (THREE.Mesh)(new (THREE.CubeGeometry)(3, 6, 3), new (THREE.MeshLambertMaterial)(color: 0x3498db))
        # @player.position.y = 2
        # @player.position.x = 5
        # @player.position.z = 5
        # @player.castShadow = true
        # @player.receiveShadow = true
        # scene.add @player


    update: () ->
        for agent in @agents
            agent.update()


    addAgent: (town,targetTown, x,y) ->
        agent = new Agent(town,targetTown, x,y)
        @agents.push agent
        return agent

