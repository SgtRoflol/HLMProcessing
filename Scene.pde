class Scene{
    Wall[] Waende;
    Enemy[] Gegners;
    
    Scene(String FileNameWalls,String FileNameEnemies) {
        loadWalls(FileNameWalls);
        loadEnemies(FileNameEnemies);
    }
    
    void loadWalls(String FileName) {
        JSONArray values = loadJSONArray(FileName);
        Waende = new Wall[values.size()];
        for (int i = 0; i < values.size(); i++) {
            
            JSONObject Wand = values.getJSONObject(i); 
            
            int PosX = Wand.getInt("PosX");
            int PosY = Wand.getInt("PosY");
            int Width = Wand.getInt("Width");
            int Height = Wand.getInt("Height");
            
            Waende[i] = new Wall(new PVector(PosX,PosY),Width,Height);   
        }
        
    }
    
    void loadEnemies(String FileName) {
        JSONArray values = loadJSONArray(FileName);
        Gegners = new Enemy[values.size()];
        
        for (int i = 0;i < values.size(); i++) {
            
            JSONObject Gegner = values.getJSONObject(i);
            int PosX = Gegner.getInt("PosX");
            int PosY = Gegner.getInt("PosY");
            
            Gegners[i] = new Enemy(new PVector(PosX,PosY),Waende);
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
