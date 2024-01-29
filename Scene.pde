class Scene{
    Wall[] Waende;
    Enemy[] Gegners;
    
    Scene() {
        Waende = new Wall[3];
        Waende[0] = new Wall(new PVector(700,200),300,100);
        Waende[1] = new Wall(new PVector(200,600),200,70);
        Waende[2] = new Wall(new PVector(10,100),300,100);
        
        Gegners = new Enemy[15];
        for (int i = 0; i < Gegners.length; i++) {
            Gegners[i] = new Enemy(new PVector(i * 60, 400));
            Gegners[i].getWalls(Waende);
        }
    }
    
    void setPlayer(Player Play) {
        for (Enemy Gegner : Gegners) {
            Gegner.setPlayer(Play);
        }
    }
    
    void render() {
        for (Wall Wand : Waende) {
            Wand.render();
        }
        
        for (Enemy Gegner : Gegners) {
            Gegner.setProjectiles(PlayerProj);
            Gegner.render();
        }
    }
    
    Wall[] getWalls() {
        return this.Waende;
    }
}
