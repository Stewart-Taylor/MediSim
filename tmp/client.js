(function() {
  var Agent, AgentManager, Building, CameraManager, ControlManager, Farm, GameManager, HealthBar, LevelManager, LightManager, PathFinder, PathFinderTester, TOWN_COLORS, TOWN_COUNT, Tile, Town, World, WorldGenerator, gameManager;

  Agent = (function() {
    function Agent(pathfinder, world, town, x, y, isGuard) {
      var material;
      this.x = x;
      this.y = y;
      this.town = town;
      this.pathfinder = pathfinder;
      this.path = [];
      this.healthBar = new HealthBar(this);
      material = new THREE.MeshLambertMaterial({
        color: this.town.color
      });
      this.cube = new THREE.Mesh(new THREE.BoxGeometry(1, 3, 1), material);
      this.cube.position.y = 3;
      this.cube.position.x = x * 5;
      this.cube.position.z = y * 5;
      this.cube.castShadow = false;
      this.cube.receiveShadow = false;
      this.town.world.scene.add(this.cube);
      this.world = world;
      this.target = null;
      this.speed = 0.01;
      this.health = 1000;
      this.maxHealth = this.health;
      this.strength = 1;
      this.active = true;
      this.isGuard = isGuard;
      this.homeGuardX = this.x + (Math.floor(Math.random() * 2) + 1) - (Math.floor(Math.random() * 2) + 1);
      this.homeGuardY = this.y + (Math.floor(Math.random() * 2) + 1) - (Math.floor(Math.random() * 2) + 1);
    }

    Agent.prototype.updateTarget = function() {
      var closeTown, closeUnit;
      closeTown = this.getClosestTargetTown();
      closeUnit = this.getClosestUnitTarget();
      if (closeTown !== null && closeUnit !== null) {
        if (closeTown.distance < closeUnit.distance) {
          this.target = closeTown.target;
          this.targetX = this.target.x;
          return this.targetY = this.target.y;
        } else {
          this.target = closeUnit.target;
          this.targetX = this.target.x;
          return this.targetY = this.target.y;
        }
      } else if (closeTown === null && closeUnit !== null) {
        this.target = closeUnit.target;
        this.targetX = this.target.x;
        return this.targetY = this.target.y;
      } else if (closeTown !== null && closeUnit === null) {
        this.target = closeTown.target;
        this.targetX = this.target.x;
        return this.targetY = this.target.y;
      } else {
        return null;
      }
    };

    Agent.prototype.getClosestUnitTarget = function() {
      var closeUnitTarget, j, len, minUnitDistance, ref, targetObject, tempAgent, totalDistance, xDistance, yDistance;
      closeUnitTarget = null;
      minUnitDistance = 100000;
      ref = this.world.agentManager.agents;
      for (j = 0, len = ref.length; j < len; j++) {
        tempAgent = ref[j];
        if (tempAgent.active === true) {
          if (this.town.id !== tempAgent.town.id) {
            xDistance = Math.abs(this.x - tempAgent.x);
            yDistance = Math.abs(this.y - tempAgent.y);
            totalDistance = xDistance + yDistance;
            if (totalDistance < minUnitDistance) {
              minUnitDistance = totalDistance;
              closeUnitTarget = tempAgent;
            }
          }
        }
      }
      if (closeUnitTarget != null) {
        targetObject = {};
        targetObject.target = closeUnitTarget;
        targetObject.distance = minUnitDistance;
        return targetObject;
      } else {
        return null;
      }
    };

    Agent.prototype.seekTarget = function() {
      var closeUnitTarget, j, len, minUnitDistance, ref, tempAgent, totalDistance, xDistance, yDistance;
      closeUnitTarget = null;
      minUnitDistance = 100000;
      ref = this.world.agentManager.agents;
      for (j = 0, len = ref.length; j < len; j++) {
        tempAgent = ref[j];
        if (tempAgent.active === true) {
          if (this.town.id !== tempAgent.town.id) {
            xDistance = Math.abs(this.x - tempAgent.x);
            yDistance = Math.abs(this.y - tempAgent.y);
            totalDistance = xDistance + yDistance;
            if (totalDistance < minUnitDistance) {
              minUnitDistance = totalDistance;
              closeUnitTarget = tempAgent;
            }
          }
        }
      }
      if (closeUnitTarget != null) {
        if (minUnitDistance < 5) {
          return closeUnitTarget;
        } else {
          return null;
        }
      } else {
        return null;
      }
    };

    Agent.prototype.getClosestTargetTown = function() {
      var closestTown, j, len, minTownDistance, ref, targetObject, totalDistance, town, xDistance, yDistance;
      closestTown = null;
      minTownDistance = 10000;
      ref = this.world.towns;
      for (j = 0, len = ref.length; j < len; j++) {
        town = ref[j];
        if (town.id !== this.town.id) {
          xDistance = Math.abs(this.x - town.x);
          yDistance = Math.abs(this.y - town.y);
          totalDistance = xDistance + yDistance;
          if (totalDistance < minTownDistance) {
            minTownDistance = totalDistance;
            closestTown = town;
          }
        }
      }
      if (closestTown != null) {
        targetObject = {};
        targetObject.target = closestTown;
        targetObject.distance = minTownDistance;
        return targetObject;
      } else {
        return null;
      }
    };

    Agent.prototype.update = function() {
      this.checkAgentsHealth();
      if (this.active === true) {
        this.healthBar.update();
        if (this.target === null) {
          if (this.isGuard === false) {
            this.updateTarget();
          } else {
            this.target = this.seekTarget();
            if (this.target !== null) {
              this.targetX = this.target.x;
              this.targetY = this.target.y;
            }
          }
        }
        if (this.target !== null) {
          return this.moveTowardsTarget();
        } else {
          if (this.isGuard) {
            return this.moveToBase();
          }
        }
      }
    };

    Agent.prototype.moveToBase = function() {
      return this.moveToCoordinates(this.homeGuardX, this.homeGuardY);
    };

    Agent.prototype.checkAgentsHealth = function() {
      if (this.health <= 0) {
        this.cube.position.y += 10;
        return this.active = false;
      }
    };

    Agent.prototype.isAtTarget = function() {
      var xd2, yd2;
      xd2 = Math.abs(this.targetX - this.x);
      yd2 = Math.abs(this.targetY - this.y);
      if (xd2 < 1 && yd2 < 1) {
        return true;
      } else {
        return false;
      }
    };

    Agent.prototype.attackTarget = function() {
      if (this.target instanceof Town) {
        if (this.target !== this.town.id) {
          this.damage(1);
          return this.target.damageTown(this, 1);
        } else {
          return this.target = null;
        }
      } else if (this.target instanceof Agent) {
        if (this.target.active === true) {
          this.target.damage(1);
          return this.cube.rotation.y += 0.2;
        } else {
          return this.target = null;
        }
      } else {
        return this.cube.rotation.z += 1;
      }
    };

    Agent.prototype.damage = function(damageAmount) {
      this.health -= damageAmount;
      if (this.health < 0) {
        return this.destroyAgent();
      }
    };

    Agent.prototype.destroyAgent = function() {
      this.active = false;
      return this.healthBar.destroy();
    };

    Agent.prototype.moveTowardsTarget = function() {
      if (this.isAtTarget()) {
        return this.attackTarget();
      } else {
        return this.moveToCoordinates(this.targetX, this.targetY);
      }
    };

    Agent.prototype.moveOnPath = function() {
      var end, pathLast, start, totalDistance, xDistance, yDistance;
      if (this.path.length === 0) {
        start = {};
        start.x = this.x;
        start.y = this.y;
        end = {};
        end.x = this.targetX;
        end.y = this.targetY;
        return this.path = this.pathfinder.findPath(start, end);
      } else {
        pathLast = this.path[0];
        xDistance = pathLast.x - this.x;
        yDistance = pathLast.y - this.y;
        totalDistance = xDistance + yDistance;
        if (totalDistance < 1) {
          return this.path.splice(0, 1);
        } else {
          return this.moveToCoordinates(pathLast.x, pathLast.y);
        }
      }
    };

    Agent.prototype.moveToCoordinates = function(xCoord, yCoord) {
      var hyp, xDistance, yDistance;
      xDistance = xCoord - this.x;
      yDistance = yCoord - this.y;
      hyp = Math.sqrt((xDistance * xDistance) + (yDistance * yDistance));
      xDistance /= hyp;
      yDistance /= hyp;
      this.x += xDistance * this.speed;
      this.y += yDistance * this.speed;
      this.cube.position.x = this.x * 5;
      return this.cube.position.z = this.y * 5;
    };

    return Agent;

  })();

  HealthBar = (function() {
    function HealthBar(agent) {
      var material;
      this.agent = agent;
      material = new THREE.MeshLambertMaterial({
        color: 0xFF0000
      });
      this.cube = new THREE.Mesh(new THREE.BoxGeometry(3, 1, 0.1), material);
      this.cube.position.y = 6;
      this.cube.position.x = this.agent.x * 5;
      this.cube.position.z = this.agent.y * 5;
      this.barWidth = 3;
      this.agent.town.world.scene.add(this.cube);
    }

    HealthBar.prototype.update = function() {
      var percent;
      percent = this.agent.health / this.agent.maxHealth;
      this.cube.position.x = this.agent.x * 5;
      this.cube.position.z = this.agent.y * 5;
      this.cube.scale.x = percent;
      if (this.agent.active === false) {
        return this.cube.position.y = 99;
      }
    };

    HealthBar.prototype.destroy = function() {
      return this.agent.town.world.scene.remove(this.cube);
    };

    return HealthBar;

  })();

  PathFinder = (function() {
    function PathFinder(width, height, map) {
      var gridTile, j, len, mapTile;
      this.width = width;
      this.height = height;
      this.grid = this.createArray(width, height);
      for (j = 0, len = map.length; j < len; j++) {
        mapTile = map[j];
        gridTile = {};
        gridTile.x = mapTile.x;
        gridTile.y = mapTile.y;
        gridTile.f = 0;
        gridTile.g = 0;
        gridTile.h = 0;
        gridTile.debug = "";
        if (mapTile.isLand === true) {
          gridTile.isWall = false;
        } else {
          gridTile.isWall = true;
        }
        this.grid[gridTile.x][gridTile.y] = gridTile;
      }
    }

    PathFinder.prototype.createArray = function(length) {
      var args, arr, i;
      arr = new Array(length || 0);
      i = length;
      if (arguments.length > 1) {
        args = Array.prototype.slice.call(arguments, 1);
        while (i--) {
          arr[length - 1 - i] = this.createArray.apply(this, args);
        }
      }
      return arr;
    };

    PathFinder.prototype.findPath = function(start, end) {
      var closedList, curr, currentNode, gScore, gScoreIsBest, i, lowInd, neighbor, neighbors, openList, ret, x;
      openList = [];
      closedList = [];
      openList.push(start);
      while (openList.length > 0) {
        lowInd = 0;
        i = 0;
        while (i < openList.length) {
          if (openList[i].f < openList[lowInd].f) {
            lowInd = i;
          }
          i++;
        }
        currentNode = openList[lowInd];
        if (currentNode.x === end.x && currentNode.y === end.y) {
          curr = currentNode;
          ret = [];
          while (curr.parent) {
            ret.push(curr);
            curr = curr.parent;
          }
          return ret.reverse();
        }
        this.removeGraphNode(openList, currentNode);
        closedList.push(currentNode);
        neighbors = this.neighbors(this.grid, currentNode);
        x = 0;
        while (x < neighbors.length) {
          neighbor = neighbors[x];
          x++;
          if ((this.hasGraphNode(closedList, neighbor)) || neighbor.isWall === true) {
            continue;
          }
          gScore = currentNode.g + 1;
          gScoreIsBest = false;
          if (!this.hasGraphNode(openList, neighbor)) {
            gScoreIsBest = true;
            neighbor.h = this.heuristic(neighbor, end);
            openList.push(neighbor);
          } else if (gScore < neighbor.g) {
            gScoreIsBest = true;
          }
          if (gScoreIsBest) {
            neighbor.parent = currentNode;
            neighbor.g = gScore;
            neighbor.f = neighbor.g + neighbor.h;
          }
        }
      }
      return [];
    };

    PathFinder.prototype.removeGraphNode = function(list, node) {
      var index;
      index = list.indexOf(node);
      return list.splice(index, 1);
    };

    PathFinder.prototype.hasGraphNode = function(list, node) {
      if (list.indexOf(node) > -1) {
        return true;
      } else {
        return false;
      }
    };

    PathFinder.prototype.heuristic = function(pos1, pos2) {
      var dist;
      return dist = Math.sqrt(Math.pow(pos1.x - pos2.x, 2) + Math.pow(pos1.y - pos2.y, 2));
    };

    PathFinder.prototype.neighbors = function(grid, node) {
      var item, ret, x, y;
      ret = [];
      x = node.x;
      y = node.y;
      item = this.addTile(x - 1, y - 1);
      if (item != null) {
        ret.push(item);
      }
      item = this.addTile(x, y - 1);
      if (item != null) {
        ret.push(item);
      }
      item = this.addTile(x + 1, y - 1);
      if (item != null) {
        ret.push(item);
      }
      item = this.addTile(x - 1, y);
      if (item != null) {
        ret.push(item);
      }
      item = this.addTile(x + 1, y);
      if (item != null) {
        ret.push(item);
      }
      item = this.addTile(x - 1, y + 1);
      if (item != null) {
        ret.push(item);
      }
      item = this.addTile(x, y + 1);
      if (item != null) {
        ret.push(item);
      }
      item = this.addTile(x + 1, y + 1);
      if (item != null) {
        ret.push(item);
      }
      return ret;
    };

    PathFinder.prototype.addTile = function(x, y) {
      var tTile;
      console.log(x + "," + y);
      tTile = this.grid[Math.round(x)][Math.round(y)];
      if (tTile != null) {
        return tTile;
      } else {
        return null;
      }
    };

    return PathFinder;

  })();

  PathFinderTester = (function() {
    function PathFinderTester(PathFinder) {
      var WORLD_HEIGHT, WORLD_WIDTH, getTile, grid, isPath, path, pathFinder, printGrid, printPath, printPathGrid, rv, start, target, tile, x, y;
      WORLD_HEIGHT = 30;
      WORLD_WIDTH = 50;
      grid = [];
      y = 0;
      while (y < WORLD_HEIGHT) {
        x = 0;
        while (x < WORLD_WIDTH) {
          tile = {};
          tile.x = x;
          tile.y = y;
          rv = Math.random();
          if (rv < 0.2) {
            tile.isLand = false;
          } else {
            tile.isLand = true;
          }
          grid.push(tile);
          x++;
        }
        y++;
      }
      pathFinder = new PathFinder(WORLD_WIDTH, WORLD_HEIGHT, grid);
      start = {};
      start.x = 1;
      start.y = 1;
      target = {};
      target.x = 20;
      target.y = 20;
      path = pathFinder.findPath(start, target);
      getTile = function(x, y) {
        var j, len;
        for (j = 0, len = grid.length; j < len; j++) {
          tile = grid[j];
          if ((tile.x === x) && (tile.y === y)) {
            return tile;
          }
        }
        return null;
      };
      isPath = function(paths, x, y) {
        var j, len, pathT;
        for (j = 0, len = paths.length; j < len; j++) {
          pathT = paths[j];
          if ((pathT.x === x) && (pathT.y === y)) {
            return true;
          }
        }
        return false;
      };
      printGrid = function() {
        var lineString, temp;
        console.log("World Generated");
        console.log();
        y = 0;
        while (y < WORLD_HEIGHT) {
          lineString = "";
          x = 0;
          while (x < WORLD_WIDTH) {
            temp = getTile(x, y);
            if (temp.isLand) {
              lineString += ".";
            } else {
              lineString += "#";
            }
            x++;
          }
          console.log(lineString);
          y++;
        }
        console.log();
        return console.log();
      };
      printPath = function(path) {
        var lineString;
        console.log("Path Generated");
        console.log();
        y = 0;
        while (y < WORLD_HEIGHT) {
          lineString = "";
          x = 0;
          while (x < WORLD_WIDTH) {
            if (isPath(path, x, y)) {
              lineString += ".";
            } else {
              lineString += "#";
            }
            x++;
          }
          console.log(lineString);
          y++;
        }
        console.log();
        return console.log();
      };
      printPathGrid = function(path) {
        var lineString, temp;
        console.log("Generated");
        console.log();
        y = 0;
        while (y < WORLD_HEIGHT) {
          lineString = "";
          x = 0;
          while (x < WORLD_WIDTH) {
            temp = getTile(x, y);
            if (temp.isLand) {
              if (isPath(path, x, y)) {
                lineString += "o";
              } else {
                lineString += ".";
              }
            } else {
              lineString += "#";
            }
            x++;
          }
          console.log(lineString);
          y++;
        }
        console.log();
        return console.log();
      };
      printGrid();
      printPath(path);
      printPathGrid(path);
    }

    return PathFinderTester;

  })();

  AgentManager = (function() {
    function AgentManager(scene, world) {
      console.log("Agent Manager Module Loaded");
      this.world = world;
      this.agents = [];
      this.pathfinder = new PathFinder(world.WORLD_WIDTH, world.WORLD_HEIGHT, world.tilesPF);
    }

    AgentManager.prototype.update = function() {
      var agent, j, len, ref, results;
      ref = this.agents;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        agent = ref[j];
        results.push(agent.update());
      }
      return results;
    };

    AgentManager.prototype.removeAgent = function(removeAgent) {
      var removeAgentIndex;
      removeAgentIndex = this.agents.indexOf(removeAgent);
      return this.agents.splice(removeAgentIndex, 1);
    };

    AgentManager.prototype.addAgent = function(town, targetTown, x, y, isGuard) {
      var agent;
      agent = new Agent(this.pathfinder, town, targetTown, x, y, isGuard);
      this.agents.push(agent);
      return agent;
    };

    return AgentManager;

  })();

  CameraManager = (function() {
    function CameraManager(scene) {
      var aspect, far, fov, near;
      fov = 60;
      aspect = window.innerWidth / window.innerHeight;
      near = 1;
      far = 10000;
      this.camera = new THREE.PerspectiveCamera(fov, aspect, near, far);
      this.camera.position.x = 138;
      this.camera.position.y = 103;
      this.camera.position.z = 170;
      this.camera.rotation.x = -0.9;
      this.camera.rotation.y = 0.0;
      this.camera.rotation.z = 0;
      scene.add(this.camera);
    }

    return CameraManager;

  })();

  ControlManager = (function() {
    function ControlManager(scene, cameraManager, levelManager) {
      this.scene = scene;
      this.gameManager = gameManager;
      this.cameraManager = cameraManager;
      this.levelManager = levelManager;
      $(function() {
        return $('body').on('keydown', function(event) {
          console.log(event.type + ': ' + event.which);
          if (event.which === 87) {
            cameraManager.camera.position.z -= 1.6;
          }
          if (event.which === 83) {
            cameraManager.camera.position.z += 1.6;
          }
          if (event.which === 68) {
            cameraManager.camera.position.x += 1.6;
          }
          if (event.which === 65) {
            cameraManager.camera.position.x -= 1.6;
          }
          if (event.which === 69) {
            cameraManager.camera.position.y += 1.6;
          }
          if (event.which === 81) {
            cameraManager.camera.position.y -= 1.6;
          }
          if (event.which === 67) {
            cameraManager.camera.rotation.x -= 0.1;
          }
          if (event.which === 90) {
            cameraManager.camera.rotation.x += 0.1;
          }
          if (event.which === 80) {
            if (levelManager.paused === false) {
              levelManager.paused = true;
            } else {
              levelManager.paused = false;
            }
          }
          if (event.which === 38) {
            actorManager.player.position.z += 0.5;
          }
          if (event.which === 40) {
            actorManager.player.position.z -= 0.5;
          }
          if (event.which === 39) {
            actorManager.player.position.x -= 0.5;
          }
          if (event.which === 37) {
            return actorManager.player.position.x += 0.5;
          }
        });
      });
    }

    return ControlManager;

  })();

  GameManager = (function() {
    var cameraManager, controlManager, htmlupdate, levelManager, lightManager, stats, update;

    cameraManager = null;

    controlManager = null;

    levelManager = null;

    lightManager = null;

    stats = null;

    function GameManager(scene) {
      var render, renderer;
      renderer = new THREE.WebGLRenderer({
        antialias: true
      });
      renderer.setSize(window.innerWidth, window.innerHeight);
      renderer.setClearColor(0xffffff, 1);
      document.body.appendChild(renderer.domElement);
      scene = new THREE.Scene;
      cameraManager = new CameraManager(scene);
      levelManager = new LevelManager(scene);
      controlManager = new ControlManager(scene, cameraManager, levelManager);
      lightManager = new LightManager(scene);
      renderer.shadowMapEnabled = true;
      renderer.shadowMapSoft = true;
      renderer.shadowCameraNear = 3;
      renderer.shadowCameraFar = cameraManager.camera.far;
      renderer.shadowCameraFov = 50;
      renderer.shadowMapBias = 0.0039;
      renderer.shadowMapDarkness = 0.5;
      renderer.shadowMapWidth = 1024;
      renderer.shadowMapHeight = 1024;
      render = function() {
        requestAnimationFrame(render);
        renderer.render(scene, cameraManager.camera);
      };
      render();
    }

    GameManager.prototype.setUp = function() {
      levelManager.init();
      setInterval(function() {
        return update();
      }, 10);
      return setInterval(function() {
        return htmlupdate();
      }, 100);
    };

    update = function() {
      var timeTaken, timestart;
      timestart = Date.now();
      levelManager.update();
      return timeTaken = Date.now() - timestart;
    };

    htmlupdate = function() {
      var color, i, results;
      i = 0;
      results = [];
      while (i < levelManager.world.towns.length) {
        color = levelManager.world.towns[i].color;
        $('#town_' + (i + 1) + "_color").css("background", "#" + color.toString(16));
        $('#town_' + (i + 1) + "_pop").html("Pop:" + Math.floor(levelManager.world.towns[i].population));
        results.push(i++);
      }
      return results;
    };

    return GameManager;

  })();

  LevelManager = (function() {
    function LevelManager(scene) {
      this.world = null;
      this.scene = scene;
      this.paused = false;
    }

    LevelManager.prototype.init = function() {
      return this.world = new World(this.scene);
    };

    LevelManager.prototype.update = function() {
      if (this.paused === false) {
        return this.world.update();
      }
    };

    return LevelManager;

  })();

  LightManager = (function() {
    function LightManager(scene) {
      var x, y, z;
      x = 90;
      y = 500;
      z = 20;
      scene.add(new THREE.AmbientLight(0x212223));
      this.spotLight = new THREE.DirectionalLight(0xffffffd);
      this.spotLight.position.set(1, 1, 0);
      this.spotLight.castShadow = false;
      this.spotLight.shadowCameraVisible = true;
      scene.add(this.spotLight);
    }

    return LightManager;

  })();

  gameManager = new GameManager();

  document.addEventListener('DOMContentLoaded', function() {
    return gameManager.setUp();
  }, false);

  Building = (function() {
    function Building(town, color, x, y) {
      var height, material;
      this.town = town;
      this.x = x;
      this.y = y;
      this.color = color;
      height = 4;
      material = new THREE.MeshLambertMaterial({
        color: this.color
      });
      this.cube = new THREE.Mesh(new THREE.BoxGeometry(3, height, 3), material);
      this.cube.position.y = 1;
      this.cube.position.x = x * 5;
      this.cube.position.z = y * 5;
      this.cube.rotation.y = x * y;
      this.cube.castShadow = true;
      this.cube.receiveShadow = true;
      this.town.world.scene.add(this.cube);
      this.myTile = this.town.world.getTile(x, y);
      this.myTile.hasBuilding = true;
      this.active = true;
    }

    Building.prototype.destroy = function() {
      this.town.world.scene.remove(this.cube);
      this.myTile.hasBuilding = false;
      this.myTile.hasFarm = true;
      return this.active = false;
    };

    return Building;

  })();

  Farm = (function() {
    function Farm(town, x, y) {
      var material;
      this.x = x;
      this.y = y;
      material = new THREE.MeshLambertMaterial({
        color: 0xd35400
      });
      material.transparent = true;
      material.opacity = 0.5;
      this.cube = new THREE.Mesh(new THREE.BoxGeometry(3, 1, 3), material);
      this.cube.position.y = 1.2;
      this.cube.position.x = x * 5;
      this.cube.position.z = y * 5;
      this.cube.rotation.y = Math.random() * (10 - 1) + 1;
      this.cube.castShadow = false;
      this.cube.receiveShadow = true;
      town.world.scene.add(this.cube);
      this.myTile = town.world.getTile(x, y);
      this.value = this.myTile.value;
      this.myTile.hasFarm = true;
      this.landValue = this.value;
      this.active = true;
    }

    Farm.prototype.check = function() {
      if (this.myTile.hasBuilding === false) {
        this.myTile.hasFarm = true;
        return this.active = true;
      }
    };

    return Farm;

  })();

  Tile = (function() {
    function Tile(world, x, y, value, type) {
      var TILE_HEIGHT, TILE_WIDTH, cube, height, isWater, landMaterial, mountainMaterial, tileColor, waterMaterial;
      this.x = x;
      this.y = y;
      this.value = value;
      this.world = world;
      this.hasFarm = false;
      this.hasBuilding = false;
      tileColor = new THREE.Color(0, value, 0);
      this.isLand = true;
      this.hasOwner = false;
      this.owner = null;
      TILE_WIDTH = 5;
      TILE_HEIGHT = 5;
      if (type === 1) {
        this.isLand = true;
        landMaterial = new THREE.MeshLambertMaterial({
          color: tileColor
        });
        cube = new THREE.Mesh(new THREE.BoxGeometry(TILE_WIDTH, 1, TILE_HEIGHT), landMaterial);
      } else if (type === 2) {
        this.isLand = false;
        isWater = true;
        waterMaterial = new THREE.MeshLambertMaterial({
          color: 0x19B5FE
        });
        cube = new THREE.Mesh(new THREE.BoxGeometry(TILE_WIDTH, 1, TILE_HEIGHT), waterMaterial);
      } else if (type === 3) {
        this.isLand = false;
        isWater = true;
        height = Math.random() * (15 - 5) + 5;
        mountainMaterial = new THREE.MeshLambertMaterial({
          color: 0x95a5a6
        });
        cube = new THREE.Mesh(new THREE.CylinderGeometry(0, 7, height, 10, 10, false), mountainMaterial);
      } else if (type === 4) {
        this.isLand = true;
        landMaterial = new THREE.MeshLambertMaterial({
          color: tileColor
        });
        cube = new THREE.Mesh(new THREE.BoxGeometry(TILE_WIDTH, 1, TILE_HEIGHT), landMaterial);
      }
      cube.position.y = 1;
      cube.position.x = x * 5;
      cube.position.z = y * 5;
      cube.castShadow = false;
      cube.receiveShadow = true;
      world.scene.add(cube);
    }

    return Tile;

  })();

  Town = (function() {
    function Town(world, id, color, x, y) {
      var material;
      this.id = id;
      this.world = world;
      this.color = color;
      this.population = 10;
      this.food = 100;
      this.gold = 70;
      this.farmPrice = 100;
      this.buildings = [];
      this.newBuildingCost = 1000;
      this.unitPoints = 0;
      this.technologyFactor = 0;
      this.agents = [];
      this.aggressiveness = Math.random();
      this.farms = [];
      this.x = x;
      this.y = y;
      this.damageCounter = 100;
      this.agentsCount = 0;
      material = new THREE.MeshLambertMaterial({
        color: this.color
      });
      this.cube = new THREE.Mesh(new THREE.BoxGeometry(5, 10, 5), material);
      this.cube.position.y = 1;
      this.cube.position.x = x * 5;
      this.cube.position.z = y * 5;
      this.cube.rotation.y = Math.random() * (10 - 1) + 1;
      this.cube.castShadow = true;
      this.cube.receiveShadow = true;
      world.scene.add(this.cube);
      this.expandBorders(this.x, this.y);
      this.lastremoveCounter = 100;
      this.expandCount = 5;
    }

    Town.prototype.update = function() {
      this.food += this.calculateFood();
      this.foodDif = this.food - this.population - (this.agentsCount * 100);
      if (this.foodDif < 0) {
        this.population += this.foodDif;
        if (this.population < 10) {
          this.population = 10;
        }
        this.food = 0;
        if (this.lastremoveCounter <= 0) {
          this.removeWorstBuilding();
          this.lastremoveCounter = 100;
        }
        this.lastremoveCounter--;
      } else {
        this.food = this.food - this.population;
        this.increasePopulation();
        if (this.food > this.population * 4) {
          this.food = this.population * 4;
        }
      }
      this.population = Math.round(this.population);
      if (this.gold > this.farmPrice) {
        this.buyFarm();
      }
      return this.calculateUnitPoints();
    };

    Town.prototype.increasePopulation = function() {
      if (this.population < this.getMaxPopulation()) {
        return this.population += 1 + this.technologyFactor;
      } else {
        return this.population = this.getMaxPopulation();
      }
    };

    Town.prototype.getMaxPopulation = function() {
      var building, buildingCount, j, len, maxPopulation, ref;
      buildingCount = 0;
      ref = this.buildings;
      for (j = 0, len = ref.length; j < len; j++) {
        building = ref[j];
        if (building.active === true) {
          buildingCount++;
        }
      }
      maxPopulation = buildingCount * 100;
      maxPopulation += 100;
      return maxPopulation;
    };

    Town.prototype.removeWorstBuilding = function() {
      maxBuilding;
      var building, j, len, maxBuilding, maxValue, ref;
      maxValue = 0;
      ref = this.buildings;
      for (j = 0, len = ref.length; j < len; j++) {
        building = ref[j];
        if (building.active) {
          if (building.myTile.value > maxValue) {
            maxValue = building.myTile.value;
            maxBuilding = building;
          }
        }
      }
      if (maxBuilding != null) {
        return maxBuilding.destroy();
      }
    };

    Town.prototype.buyFarm = function() {
      var bestTile, farm;
      bestTile = this.findBestFarmTile();
      if (bestTile != null) {
        farm = new Farm(this, bestTile.x, bestTile.y);
        this.farms.push(farm);
        this.gold -= this.farmPrice;
        return this.expandBorders(bestTile.x, bestTile.y);
      } else {
        return this.expandTown();
      }
    };

    Town.prototype.expandTown = function() {
      var farm, j, len, newBuilding, newBuildingTile, ref, results;
      if (this.population >= this.getMaxPopulation()) {
        newBuildingTile = this.findWorstFarmTile();
        if (newBuildingTile != null) {
          newBuilding = new Building(this, this.color, newBuildingTile.x, newBuildingTile.y);
          this.buildings.push(newBuilding);
          this.expandBorders(newBuildingTile.x, newBuildingTile.y);
          ref = this.farms;
          results = [];
          for (j = 0, len = ref.length; j < len; j++) {
            farm = ref[j];
            if ((farm.x === newBuilding.x) && (farm.y === newBuilding.y)) {
              results.push(farm.active = false);
            } else {
              results.push(void 0);
            }
          }
          return results;
        }
      }
    };

    Town.prototype.calculateFood = function() {
      var farm, farmAmount, farmValue, foodAmount, j, len, ref, workingPopulation;
      foodAmount = 5;
      workingPopulation = this.population;
      ref = this.farms;
      for (j = 0, len = ref.length; j < len; j++) {
        farm = ref[j];
        farm.check();
        if (workingPopulation > 0) {
          if (farm.active === true) {
            farmValue = farm.value;
            farmAmount = (100 * (this.technologyFactor + 1)) * farm.value;
            foodAmount += farmAmount;
            workingPopulation -= 10;
          }
        }
      }
      this.gold += 1;
      if (workingPopulation > 0) {
        this.gold += Math.round(workingPopulation / 100);
      }
      return foodAmount;
    };

    Town.prototype.damageTown = function(attackingAgent, damageAmount) {
      var agent, building, j, k, len, len1, ref, ref1, results;
      this.population -= damageAmount;
      this.damageCounter--;
      if (this.damageCounter < 0) {
        this.removeWorstBuilding();
        this.damageCounter = 100;
      }
      if (this.population < 0) {
        this.population = 0;
        this.id = attackingAgent.town.id;
        this.color = attackingAgent.town.color;
        this.cube.material = attackingAgent.town.cube.material;
        this.population = 0;
        this.food = 0;
        this.gold = 0;
        ref = this.buildings;
        for (j = 0, len = ref.length; j < len; j++) {
          building = ref[j];
          building.cube.material = attackingAgent.town.cube.material;
        }
        ref1 = this.agents;
        results = [];
        for (k = 0, len1 = ref1.length; k < len1; k++) {
          agent = ref1[k];
          if (agent != null) {
            results.push(agent.damage(9999999));
          } else {
            results.push(void 0);
          }
        }
        return results;
      }
    };

    Town.prototype.calculateUnitPoints = function() {
      if (this.gold > this.getUnitCost()) {
        return this.buyAgent();
      }
    };

    Town.prototype.getUnitCost = function() {
      var cost;
      cost = 10000;
      return cost;
    };

    Town.prototype.buyAgent = function() {
      var agent, rValue;
      this.gold -= this.getUnitCost();
      rValue = Math.random();
      if (rValue > this.aggressiveness) {
        agent = this.world.agentManager.addAgent(this.world, this, this.x, this.y, false);
      } else {
        agent = this.world.agentManager.addAgent(this.world, this, this.x, this.y, false);
      }
      this.agents.push(agent);
      return this.unitPoints -= 1000;
    };

    Town.prototype.getAgentCount = function() {
      var aCount, agent, j, len, ref;
      aCount = 0;
      ref = this.agents;
      for (j = 0, len = ref.length; j < len; j++) {
        agent = ref[j];
        if (agent.active === true) {
          aCount++;
        }
      }
      return aCount;
    };

    Town.prototype.degradeFarmTiles = function(x, y) {
      this.degradeFarmTile(this.x, this.y - 1);
      this.degradeFarmTile(this.x - 1, this.y);
      this.degradeFarmTile(this.x + 1, this.y);
      return this.degradeFarmTile(this.x, this.y + 1);
    };

    Town.prototype.degradeFarmTile = function(x, y) {
      var currentTile, farm, j, len, ref, results;
      currentTile = this.world.getTile(x, y);
      currentTile.value -= 0.1;
      if (currentTile.value < 0.01) {
        currentTile.value = 0.01;
      }
      if (currentTile.hasFarm) {
        ref = this.farms;
        results = [];
        for (j = 0, len = ref.length; j < len; j++) {
          farm = ref[j];
          if ((x === farm.x) && (y === farm.y)) {
            results.push(farm.value = currentTile.value);
          } else {
            results.push(void 0);
          }
        }
        return results;
      }
    };

    Town.prototype.findBestFarmTile = function() {
      var building, j, len, maxTile, ref;
      maxTile = null;
      maxTile = this.isBestTile(maxTile, this.x, this.y - 1);
      maxTile = this.isBestTile(maxTile, this.x - 1, this.y - 1);
      maxTile = this.isBestTile(maxTile, this.x + 1, this.y - 1);
      maxTile = this.isBestTile(maxTile, this.x - 1, this.y);
      maxTile = this.isBestTile(maxTile, this.x + 1, this.y);
      maxTile = this.isBestTile(maxTile, this.x, this.y + 1);
      maxTile = this.isBestTile(maxTile, this.x + 1, this.y + 1);
      maxTile = this.isBestTile(maxTile, this.x - 1, this.y + 1);
      ref = this.buildings;
      for (j = 0, len = ref.length; j < len; j++) {
        building = ref[j];
        maxTile = this.isBestTile(maxTile, building.x, building.y - 1);
        maxTile = this.isBestTile(maxTile, building.x + 1, building.y - 1);
        maxTile = this.isBestTile(maxTile, building.x - 1, building.y - 1);
        maxTile = this.isBestTile(maxTile, building.x - 1, building.y);
        maxTile = this.isBestTile(maxTile, building.x + 1, building.y);
        maxTile = this.isBestTile(maxTile, building.x, building.y + 1);
        maxTile = this.isBestTile(maxTile, building.x + 1, building.y + 1);
        maxTile = this.isBestTile(maxTile, building.x - 1, building.y + 1);
      }
      return maxTile;
    };

    Town.prototype.isBestTile = function(bestTile, x, y) {
      var currentTile;
      currentTile = this.world.getTile(x, y);
      if (bestTile != null) {
        if (this.isFarmTileAvalaible(currentTile) === true) {
          if (currentTile.value > bestTile.value) {
            return currentTile;
          } else {
            return bestTile;
          }
        } else {
          return bestTile;
        }
      } else {
        if (this.isFarmTileAvalaible(currentTile)) {
          return currentTile;
        } else {
          return null;
        }
      }
    };

    Town.prototype.distanceToTown = function(x, y) {
      var distance, distanceX, distanceY;
      distanceX = Math.abs(this.x - x);
      distanceY = Math.abs(this.y - y);
      distance = distanceX + distanceY;
      return distance;
    };

    Town.prototype.buildingTileValue = function(theTile) {
      var value;
      value = theTile.value;
      return value;
    };

    Town.prototype.findWorstFarmTile = function() {
      var farm, j, len, maxTile, ref;
      maxTile = null;
      maxTile = this.isWorstTile(maxTile, this.x, this.y - 1);
      maxTile = this.isWorstTile(maxTile, this.x - 1, this.y - 1);
      maxTile = this.isWorstTile(maxTile, this.x + 1, this.y - 1);
      maxTile = this.isWorstTile(maxTile, this.x - 1, this.y);
      maxTile = this.isWorstTile(maxTile, this.x + 1, this.y);
      maxTile = this.isWorstTile(maxTile, this.x, this.y + 1);
      maxTile = this.isWorstTile(maxTile, this.x - 1, this.y + 1);
      maxTile = this.isWorstTile(maxTile, this.x + 1, this.y + 1);
      ref = this.farms;
      for (j = 0, len = ref.length; j < len; j++) {
        farm = ref[j];
        maxTile = this.isWorstTile(maxTile, farm.x, farm.y - 1);
        maxTile = this.isWorstTile(maxTile, farm.x + 1, farm.y - 1);
        maxTile = this.isWorstTile(maxTile, farm.x - 1, farm.y - 1);
        maxTile = this.isWorstTile(maxTile, farm.x - 1, farm.y);
        maxTile = this.isWorstTile(maxTile, farm.x + 1, farm.y);
        maxTile = this.isWorstTile(maxTile, farm.x, farm.y + 1);
        maxTile = this.isWorstTile(maxTile, farm.x + 1, farm.y + 1);
        maxTile = this.isWorstTile(maxTile, farm.x - 1, farm.y + 1);
      }
      return maxTile;
    };

    Town.prototype.isWorstTile = function(bestTile, x, y) {
      var currentTile;
      if (bestTile != null) {
        currentTile = this.world.getTile(x, y);
        if (this.isBuildingTileAvalaible(currentTile) === true) {
          if (this.buildingTileValue(currentTile) < this.buildingTileValue(bestTile)) {
            return currentTile;
          } else {
            return bestTile;
          }
        } else {
          return bestTile;
        }
      } else {
        currentTile = this.world.getTile(x, y);
        if (this.isBuildingTileAvalaible(currentTile)) {
          return currentTile;
        } else {
          return null;
        }
      }
    };

    Town.prototype.isFarmTileAvalaible = function(theTile) {
      if (theTile != null) {
        if (this.isOwner(theTile) === true) {
          if (theTile.isLand && theTile.hasFarm === false && theTile.hasBuilding === false) {
            if (this.hasOtherBorder(theTile.x, theTile.y) === false) {
              return true;
            }
          }
        }
      }
      return false;
    };

    Town.prototype.isOwner = function(theTile) {
      if (theTile.hasOwner === false) {
        return false;
      } else {
        if (theTile.owner.id === this.id) {
          return true;
        }
      }
    };

    Town.prototype.hasOtherBorder = function(x, y) {
      var count;
      count = 0;
      count += this.isOtherBorder(x - 1, y - 1);
      count += this.isOtherBorder(x, y - 1);
      count += this.isOtherBorder(x + 1, y - 1);
      count += this.isOtherBorder(x - 1, y);
      count += this.isOtherBorder(x + 1, y);
      count += this.isOtherBorder(x - 1, y + 1);
      count += this.isOtherBorder(x, y + 1);
      count += this.isOtherBorder(x + 1, y + 1);
      if (count > 0) {
        return true;
      } else {
        return false;
      }
    };

    Town.prototype.isOtherBorder = function(x, y) {
      var otherTile;
      otherTile = this.world.getTile(x, y);
      if (otherTile != null) {
        if (otherTile.hasOwner === true) {
          if (otherTile.owner.id === this.id) {
            return 0;
          } else {
            return 1;
          }
        } else {
          return 0;
        }
      } else {
        return 0;
      }
    };

    Town.prototype.isBuildingTileAvalaible = function(theTile) {
      if (theTile != null) {
        if (theTile.hasFarm === true && theTile.hasBuilding === false && this.isOwner(theTile) === true) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    };

    Town.prototype.expandBorders = function(x, y) {
      this.claimTile(x - 1, y - 1);
      this.claimTile(x, y - 1);
      this.claimTile(x + 1, y - 1);
      this.claimTile(x - 1, y);
      this.claimTile(x + 1, y);
      this.claimTile(x - 1, y + 1);
      this.claimTile(x, y + 1);
      return this.claimTile(x + 1, y + 1);
    };

    Town.prototype.removeAgent = function(removeAgent) {
      var removeAgentIndex;
      removeAgentIndex = this.agents.indexOf(removeAgent);
      this.agents.splice(removeAgentIndex, 1);
      return this.world.agentManager.removeAgent(removeAgent);
    };

    Town.prototype.claimTile = function(x, y) {
      var claimTile;
      claimTile = this.world.getTile(x, y);
      if (claimTile != null) {
        if (claimTile.hasOwner === false) {
          if (this.hasOtherBorder(x, y) === false) {
            claimTile.hasOwner = true;
            return claimTile.owner = this;
          }
        }
      }
    };

    return Town;

  })();

  TOWN_COLORS = [0xe74c3c, 0xe67e22, 0x6BB9F0, 0xDB0A5B, 0xF2784B, 0x90C695, 0xBE90D4, 0x8e44ad];

  TOWN_COUNT = TOWN_COLORS.length;

  World = (function() {
    function World(scene) {
      var worldGenerator;
      this.scene = scene;
      this.towns = [];
      this.tiles = [];
      this.tilesPF = [];
      worldGenerator = new WorldGenerator();
      this.WORLD_WIDTH = worldGenerator.WORLD_WIDTH;
      this.WORLD_HEIGHT = worldGenerator.WORLD_HEIGHT;
      this.createWorld(worldGenerator);
      this.agentManager = new AgentManager(scene, this);
      this.placeTowns(worldGenerator);
    }

    World.prototype.createWorld = function(worldGenerator) {
      var grid, gridTile, j, len, newTile, results;
      grid = worldGenerator.generateWorld();
      this.tiles = this.createArray(worldGenerator.WORLD_WIDTH, worldGenerator.WORLD_HEIGHT);
      results = [];
      for (j = 0, len = grid.length; j < len; j++) {
        gridTile = grid[j];
        newTile = new Tile(this, gridTile.x, gridTile.y, gridTile.value, gridTile.type);
        this.tiles[gridTile.x][gridTile.y] = newTile;
        results.push(this.tilesPF.push(newTile));
      }
      return results;
    };

    World.prototype.createArray = function(length) {
      var args, arr, i;
      arr = new Array(length || 0);
      i = length;
      if (arguments.length > 1) {
        args = Array.prototype.slice.call(arguments, 1);
        while (i--) {
          arr[length - 1 - i] = this.createArray.apply(this, args);
        }
      }
      return arr;
    };

    World.prototype.placeTowns = function() {
      var placeCount, results, town, townTile, x, y;
      placeCount = 0;
      results = [];
      while (placeCount < TOWN_COUNT) {
        x = Math.floor((Math.random() * this.WORLD_WIDTH - 1) + 1);
        y = Math.floor((Math.random() * this.WORLD_HEIGHT - 1) + 1);
        townTile = this.getTile(x, y);
        if (this.canPlaceTown(townTile)) {
          town = new Town(this, placeCount + 1, TOWN_COLORS[placeCount], x, y);
          this.towns.push(town);
          results.push(placeCount++);
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    World.prototype.canPlaceTown = function(townTile) {
      var invalidCount, j, len, ref, town, xDistance, yDistance;
      if (townTile != null) {
        if (townTile.isLand) {
          invalidCount = 0;
          if (this.isAdjacentTileLand(townTile.x - 1, townTile.y - 1) === false) {
            invalidCount++;
          }
          if (this.isAdjacentTileLand(townTile.x, townTile.y - 1) === false) {
            invalidCount++;
          }
          if (this.isAdjacentTileLand(townTile.x + 1, townTile.y - 1) === false) {
            invalidCount++;
          }
          if (this.isAdjacentTileLand(townTile.x - 1, townTile.y) === false) {
            invalidCount++;
          }
          if (this.isAdjacentTileLand(townTile.x + 1, townTile.y) === false) {
            invalidCount++;
          }
          if (this.isAdjacentTileLand(townTile.x - 1, townTile.y + 1) === false) {
            invalidCount++;
          }
          if (this.isAdjacentTileLand(townTile.x, townTile.y + 1) === false) {
            invalidCount++;
          }
          if (this.isAdjacentTileLand(townTile.x + 1, townTile.y + 1) === false) {
            invalidCount++;
          }
          if (invalidCount === 0) {
            ref = this.towns;
            for (j = 0, len = ref.length; j < len; j++) {
              town = ref[j];
              xDistance = Math.abs(townTile.x - town.x);
              yDistance = Math.abs(townTile.y - town.y);
              if ((xDistance + yDistance) < 8) {
                return false;
              }
            }
            return true;
          }
        }
      }
      return false;
    };

    World.prototype.isAdjacentTileLand = function(x, y) {
      var tile;
      tile = this.getTile(x, y);
      if (tile != null) {
        if (tile.isLand) {
          return true;
        }
      }
      return false;
    };

    World.prototype.update = function() {
      var j, len, ref, town;
      ref = this.towns;
      for (j = 0, len = ref.length; j < len; j++) {
        town = ref[j];
        town.update();
      }
      return this.agentManager.update();
    };

    World.prototype.getTile = function(x, y) {
      if ((x > 0) && (x < this.WORLD_WIDTH)) {
        if ((y > 0) && (y < this.WORLD_HEIGHT)) {
          return this.tiles[x][y];
        }
      }
      return null;
    };

    return World;

  })();

  WorldGenerator = (function() {
    var COAST_ERODE_PASSES, LAKE_TILE, LAKE_TILE_CHAR, LAND_TILE, LAND_TILE_CHAR, MOUNTAIN_PASSES, MOUNTAIN_TILE, MOUNTAIN_TILE_CHAR, TREE_PASSES, TREE_TILE, TREE_TILE_CHAR, WATER_TILE, WATER_TILE_CHAR, WORLD_HEIGHT, WORLD_WIDTH;

    WORLD_WIDTH = 60;

    WORLD_HEIGHT = 30;

    COAST_ERODE_PASSES = 5;

    MOUNTAIN_PASSES = 7;

    TREE_PASSES = 7;

    LAND_TILE = 1;

    LAND_TILE_CHAR = "#";

    WATER_TILE = 2;

    WATER_TILE_CHAR = ".";

    MOUNTAIN_TILE = 3;

    MOUNTAIN_TILE_CHAR = "^";

    TREE_TILE = 4;

    TREE_TILE_CHAR = "|";

    LAKE_TILE = 5;

    LAKE_TILE_CHAR = ".";

    function WorldGenerator() {
      this.WORLD_WIDTH = 60;
      this.WORLD_HEIGHT = 30;
      this.map = [];
      this.mpass_value = 0.5;
    }

    WorldGenerator.prototype.generateWorld = function() {
      var timestart;
      timestart = Date.now();
      this.createBaseLand();
      this.createWaterEdges();
      this.coastErode();
      this.addMountains();
      this.generateYield();
      this.addLakes();
      this.addTrees();
      this.convertLakeToWater();
      this.time_taken = Date.now() - timestart;
      return this.map;
    };

    WorldGenerator.prototype.convertLakeToWater = function() {
      var j, len, ref, results, tile;
      ref = this.map;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        tile = ref[j];
        if (tile.type === LAKE_TILE) {
          results.push(tile.type = WATER_TILE);
        } else {
          results.push(void 0);
        }
      }
      return results;
    };

    WorldGenerator.prototype.addLakes = function() {
      var mountainPlaces, mountainTiles, mpass_value, passes, rX, rY, results, tile;
      mountainTiles = [];
      mountainPlaces = 2;
      while (mountainPlaces > 0) {
        rX = Math.floor(Math.random() * WORLD_WIDTH) + 1;
        rY = Math.floor(Math.random() * WORLD_HEIGHT) + 1;
        tile = this.getTile(rX, rY);
        if (tile != null) {
          if (tile.type === LAND_TILE) {
            tile.type = LAKE_TILE;
            mountainTiles.push(tile);
            mountainPlaces--;
          }
        }
      }
      passes = Math.floor(Math.random() * TREE_PASSES) + 8;
      results = [];
      while (passes > 0) {
        this.lakePass();
        this.mpass_value -= 0.1;
        if (mpass_value < 0.1) {
          mpass_value = 0.1;
        }
        results.push(passes--);
      }
      return results;
    };

    WorldGenerator.prototype.lakePass = function() {
      var j, k, len, len1, mountainTile, mountainTiles, ref, results, tile;
      mountainTiles = [];
      ref = this.map;
      for (j = 0, len = ref.length; j < len; j++) {
        tile = ref[j];
        if (tile.type === LAKE_TILE) {
          mountainTiles.push(tile);
        }
      }
      results = [];
      for (k = 0, len1 = mountainTiles.length; k < len1; k++) {
        mountainTile = mountainTiles[k];
        this.convertLakeTile(mountainTile.x, mountainTile.y - 1);
        this.convertLakeTile(mountainTile.x + 1, mountainTile.y);
        this.convertLakeTile(mountainTile.x - 1, mountainTile.y);
        results.push(this.convertLakeTile(mountainTile.x, mountainTile.y + 1));
      }
      return results;
    };

    WorldGenerator.prototype.convertLakeTile = function(x, y) {
      var rValue, tile;
      tile = this.getTile(x, y);
      if (tile != null) {
        rValue = Math.random();
        if (rValue < 0.5) {
          if (tile.type === LAND_TILE) {
            return tile.type = LAKE_TILE;
          }
        }
      }
    };

    WorldGenerator.prototype.addTrees = function() {
      var mountainPlaces, mountainTiles, mpass_value, passes, rX, rY, results, tile;
      mountainTiles = [];
      mountainPlaces = 7;
      while (mountainPlaces > 0) {
        rX = Math.floor(Math.random() * WORLD_WIDTH) + 1;
        rY = Math.floor(Math.random() * WORLD_HEIGHT) + 1;
        tile = this.getTile(rX, rY);
        if (tile != null) {
          if (tile.type === LAND_TILE) {
            tile.type = TREE_TILE;
            mountainTiles.push(tile);
            mountainPlaces--;
          }
        }
      }
      passes = Math.floor(Math.random() * TREE_PASSES) + 3;
      results = [];
      while (passes > 0) {
        this.treePass();
        this.mpass_value -= 0.1;
        if (mpass_value < 0.1) {
          mpass_value = 0.1;
        }
        results.push(passes--);
      }
      return results;
    };

    WorldGenerator.prototype.treePass = function() {
      var j, k, len, len1, mountainTile, mountainTiles, ref, results, tile;
      mountainTiles = [];
      ref = this.map;
      for (j = 0, len = ref.length; j < len; j++) {
        tile = ref[j];
        if (tile.type === TREE_TILE) {
          mountainTiles.push(tile);
        }
      }
      results = [];
      for (k = 0, len1 = mountainTiles.length; k < len1; k++) {
        mountainTile = mountainTiles[k];
        this.convertTreeTile(mountainTile.x, mountainTile.y - 1);
        this.convertTreeTile(mountainTile.x + 1, mountainTile.y);
        this.convertTreeTile(mountainTile.x - 1, mountainTile.y);
        results.push(this.convertTreeTile(mountainTile.x, mountainTile.y + 1));
      }
      return results;
    };

    WorldGenerator.prototype.convertTreeTile = function(x, y) {
      var rValue, tile;
      tile = this.getTile(x, y);
      if (tile != null) {
        rValue = Math.random();
        if (rValue < 0.5) {
          if (tile.type === LAND_TILE) {
            return tile.type = TREE_TILE;
          }
        }
      }
    };

    WorldGenerator.prototype.generateYield = function() {
      var j, len, passes, rValue, ref, results, tile;
      ref = this.map;
      for (j = 0, len = ref.length; j < len; j++) {
        tile = ref[j];
        if (tile.type === LAND_TILE) {
          rValue = Math.random();
          if (rValue < 0.2) {
            rValue = 0.2;
          }
          tile.value = rValue;
        } else {
          tile.value = 0;
        }
      }
      passes = 1;
      results = [];
      while (passes > 0) {
        this.smoothYield();
        results.push(passes--);
      }
      return results;
    };

    WorldGenerator.prototype.smoothYield = function() {
      var avg, j, len, ref, results, tile, tileCount, total;
      ref = this.map;
      results = [];
      for (j = 0, len = ref.length; j < len; j++) {
        tile = ref[j];
        total = 0;
        tileCount = 9;
        total += this.adjacentTileLandValue(tile.x - 1, tile.y - 1);
        total += this.adjacentTileLandValue(tile.x, tile.y - 1);
        total += this.adjacentTileLandValue(tile.x + 1, tile.y - 1);
        total += this.adjacentTileLandValue(tile.x - 1, tile.y);
        total += this.adjacentTileLandValue(tile.x + 1, tile.y);
        total += this.adjacentTileLandValue(tile.x - 1, tile.y + 1);
        total += this.adjacentTileLandValue(tile.x, tile.y + 1);
        total += this.adjacentTileLandValue(tile.x + 1, tile.y + 1);
        avg = total / tileCount;
        if (avg < 0.2) {
          avg = 0.2;
        }
        results.push(tile.value = avg);
      }
      return results;
    };

    WorldGenerator.prototype.adjacentTileLandValue = function(x, y) {
      var tile;
      tile = this.getTile(x, y);
      if (tile != null) {
        if (tile.type === LAND_TILE) {
          return tile.value;
        }
      }
      return 0;
    };

    WorldGenerator.prototype.addMountains = function() {
      var mountainPlaces, mountainTiles, mpass_value, passes, rX, rY, results, tile;
      mountainTiles = [];
      mountainPlaces = 4;
      while (mountainPlaces > 0) {
        rX = Math.floor(Math.random() * WORLD_WIDTH) + 1;
        rY = Math.floor(Math.random() * WORLD_HEIGHT) + 1;
        tile = this.getTile(rX, rY);
        if (tile != null) {
          if (tile.type === LAND_TILE) {
            tile.type = MOUNTAIN_TILE;
            mountainTiles.push(tile);
            mountainPlaces--;
          }
        }
      }
      passes = Math.floor(Math.random() * MOUNTAIN_PASSES) + 3;
      results = [];
      while (passes > 0) {
        this.mountainPass();
        this.mpass_value -= 0.1;
        if (mpass_value < 0.1) {
          mpass_value = 0.1;
        }
        results.push(passes--);
      }
      return results;
    };

    WorldGenerator.prototype.mountainPass = function() {
      var j, k, len, len1, mountainTile, mountainTiles, ref, results, tile;
      mountainTiles = [];
      ref = this.map;
      for (j = 0, len = ref.length; j < len; j++) {
        tile = ref[j];
        if (tile.type === MOUNTAIN_TILE) {
          mountainTiles.push(tile);
        }
      }
      results = [];
      for (k = 0, len1 = mountainTiles.length; k < len1; k++) {
        mountainTile = mountainTiles[k];
        this.convertMountainTile(mountainTile.x, mountainTile.y - 1);
        this.convertMountainTile(mountainTile.x + 1, mountainTile.y);
        this.convertMountainTile(mountainTile.x - 1, mountainTile.y);
        results.push(this.convertMountainTile(mountainTile.x, mountainTile.y + 1));
      }
      return results;
    };

    WorldGenerator.prototype.convertMountainTile = function(x, y) {
      var rValue, tile;
      tile = this.getTile(x, y);
      if (tile != null) {
        rValue = Math.random();
        if (rValue < this.mpass_value) {
          if (tile.type === LAND_TILE) {
            return tile.type = MOUNTAIN_TILE;
          }
        }
      }
    };

    WorldGenerator.prototype.createBaseLand = function() {
      var results, tile, x, y;
      y = 0;
      results = [];
      while (y < WORLD_HEIGHT) {
        x = 0;
        while (x < WORLD_WIDTH) {
          tile = {};
          tile.x = x;
          tile.y = y;
          tile.type = LAND_TILE;
          this.map.push(tile);
          x++;
        }
        results.push(y++);
      }
      return results;
    };

    WorldGenerator.prototype.createWaterEdges = function() {
      var results, tile1, tile2, x, y;
      x = 0;
      while (x < WORLD_WIDTH) {
        tile1 = this.getTile(x, 0);
        tile2 = this.getTile(x, WORLD_HEIGHT - 1);
        if (tile1 != null) {
          tile1.type = WATER_TILE;
        }
        if (tile2 != null) {
          tile2.type = WATER_TILE;
        }
        x++;
      }
      y = 0;
      results = [];
      while (y < WORLD_HEIGHT) {
        tile1 = this.getTile(0, y);
        tile2 = this.getTile(WORLD_WIDTH - 1, y);
        if (tile1 != null) {
          tile1.type = WATER_TILE;
        }
        if (tile2 != null) {
          tile2.type = WATER_TILE;
        }
        results.push(y++);
      }
      return results;
    };

    WorldGenerator.prototype.coastErode = function() {
      var results, waterPasses;
      waterPasses = COAST_ERODE_PASSES;
      results = [];
      while (waterPasses > 0) {
        this.waterAdjactent();
        results.push(waterPasses--);
      }
      return results;
    };

    WorldGenerator.prototype.waterAdjactent = function() {
      var j, k, len, len1, ref, results, tile, waterTile, waterTiles;
      waterTiles = [];
      ref = this.map;
      for (j = 0, len = ref.length; j < len; j++) {
        tile = ref[j];
        if (tile.type === WATER_TILE) {
          waterTiles.push(tile);
        }
      }
      results = [];
      for (k = 0, len1 = waterTiles.length; k < len1; k++) {
        waterTile = waterTiles[k];
        this.waterTileConvert(waterTile.x, waterTile.y - 1);
        this.waterTileConvert(waterTile.x + 1, waterTile.y);
        this.waterTileConvert(waterTile.x - 1, waterTile.y);
        results.push(this.waterTileConvert(waterTile.x, waterTile.y + 1));
      }
      return results;
    };

    WorldGenerator.prototype.waterTileConvert = function(x, y) {
      var rValue, tile;
      tile = this.getTile(x, y);
      if (tile != null) {
        rValue = Math.random();
        if (rValue < 0.5) {
          return tile.type = WATER_TILE;
        }
      }
    };

    WorldGenerator.prototype.getTile = function(x, y) {
      var j, len, ref, tile;
      ref = this.map;
      for (j = 0, len = ref.length; j < len; j++) {
        tile = ref[j];
        if ((tile.x === x) && (tile.y === y)) {
          return tile;
        }
      }
      return null;
    };

    WorldGenerator.prototype.printMapToConsole = function() {
      var lineString, x, y;
      console.log("World Generated");
      console.log();
      y = 0;
      while (y < WORLD_HEIGHT) {
        lineString = "";
        x = 0;
        while (x < WORLD_WIDTH) {
          lineString += this.getTileChar(gen.getTile(x, y).type);
          x++;
        }
        console.log(lineString);
        y++;
      }
      console.log();
      console.log("" + this.time_taken + "ms");
      return console.log();
    };

    WorldGenerator.prototype.getTileChar = function(type) {
      if (type === LAND_TILE) {
        return LAND_TILE_CHAR;
      } else if (type === WATER_TILE) {
        return WATER_TILE_CHAR;
      } else if (type === MOUNTAIN_TILE) {
        return MOUNTAIN_TILE_CHAR;
      } else if (type === TREE_TILE) {
        return TREE_TILE_CHAR;
      }
    };

    return WorldGenerator;

  })();

}).call(this);
