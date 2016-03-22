
class HealthBar

    constructor: (agent) ->
        @agent = agent

        material = new (THREE.MeshLambertMaterial)(color: 0xFF0000)
        @cube = new (THREE.Mesh)(new (THREE.BoxGeometry)(3, 1, 0.1), material)
        @cube.position.y = 6
        @cube.position.x = @agent.x * 5
        @cube.position.z = @agent.y * 5

        @barWidth = 3

        @agent.town.world.scene.add @cube


    update: () ->
        percent = @agent.health / @agent.maxHealth

        @cube.position.x = @agent.x * 5
        @cube.position.z = @agent.y * 5


        @cube.scale.x = percent

        if @agent.active == false
            @cube.position.y = 99
        #update the health bar to
