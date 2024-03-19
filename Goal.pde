class Goal{
    PVector Pos;
    int w;
    int h;
    
    Goal(int x, int y, int w, int h) {
        Pos = new PVector(x,y);
        this.w = w;
        this.h = h;
    }
    
    void render() {
        //Wenn alle Gegner besiegt wurden, wird das Ziel gerendert
        if (CurScene.enemyAmount == 0) {
            fill(255,255,0);
            rect(Pos.x + 20,Pos.y - 20,w - 20,h - 20);
        }
    }
    
    
    boolean playerOnTop() {
        //Wenn der Spieler auf dem Ziel ist, wird true zurückgegeben
        if (CurScene.enemyAmount == 0) {
            if (Play.x + worldCamera.Pos.x >= Pos.x && Play.x + worldCamera.Pos.x  <= Pos.x + w && 
                Play.y + worldCamera.Pos.y >= Pos.y && Play.y + worldCamera.Pos.y <= Pos.y + h) {
                return true;
            }
        }
        return false;
    }
}
