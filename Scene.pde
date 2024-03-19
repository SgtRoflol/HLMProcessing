class Scene{
    Wall[] Waende;
    Enemy[] Gegners;
    PVector StartingPos;
    String FileNameEnemies;
    int enemyAmount;
    
    //Konstruktor
    Scene(String FileNameWalls,String FileNameEnemies) {
        this.FileNameEnemies = FileNameEnemies;
        loadWalls(FileNameWalls);
        loadEnemies(FileNameEnemies);
        StartingPos = new PVector(0,0);
    }
    
    void loadWalls(String FileName) {
        //Wenn der Spieler das Level 5 erreicht hat, wird das Spiel beendet
        if (savedLevel >= 5 || curLevel >= 5) {
            finished = true;
            return;
        }
        //Lädt die Wände aus einer JSON Datei
        JSONArray values = loadJSONArray(FileName);
        Waende = new Wall[values.size()];
        for (int i = 0; i < values.size(); i++) {
            //Lädt die Werte aus der JSON Datei und speichert sie in die Wand
            JSONObject Wand = values.getJSONObject(i); 
            
            int PosX = Wand.getInt("PosX");
            int PosY = Wand.getInt("PosY");
            int Width = Wand.getInt("Width");
            int Height = Wand.getInt("Height");
            
            Waende[i] = new Wall(new PVector(PosX,PosY),Width,Height);   
        }
        
    }
    //Lädt die Gegner aus einer JSON Datei
    void loadEnemies(String FileName) {
        if (!finished) {
            JSONArray values = loadJSONArray(FileName);
            if (values == null) {
                //Wenn die JSON Datei nicht existiert, wird das Spiel beendet
                finished = true;
                menu = false;
                return;
            }
            //Lädt die Werte aus der JSON Datei und speichert sie in die Gegner
            Gegners = new Enemy[values.size()];
            
            for (int i = 0;i < values.size(); i++) {
                
                JSONObject Gegner = values.getJSONObject(i);
                int PosX = Gegner.getInt("PosX");
                int PosY = Gegner.getInt("PosY");
                
                Gegners[i] = new Enemy(new PVector(PosX,PosY),Waende);
            }
            //Setzt den Spieler für die Gegner
            setPlayer(Play);
            //Speichert die Anzahl der Gegner
            enemyAmount = Gegners.length;
        }
    }
    
    //Setzt den Spieler für die Gegner
    void setPlayer(Player Play) {
        for (Enemy Gegner : Gegners) {
            Gegner.setPlayer(Play);
        }
    }
    
    
    void render() {
        //Zeichnet die Wände und die Gegner
        for (Wall Wand : Waende) {
            Wand.render();
        }
        for (Enemy Gegner : Gegners) {
            Gegner.setProjectiles(PlayerProj);
            Gegner.render();
        }
    }
    
    //Gibt die Wände zurück
    Wall[] getWalls() {
        return this.Waende;
    }
    
    void init() {
        //Lädt die Gegner
        loadEnemies(FileNameEnemies);
    }
    
}
