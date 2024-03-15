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
        if (CurScene.enemyAmount == 0) {
            fill(255,255,0);
            rect(Pos.x,Pos.y,w,h);
        }
    }
    
    
    boolean playerOnTop() {
        if (CurScene.enemyAmount == 0) {
            if (Play.x + worldCamera.Pos.x >= Pos.x && Play.x + worldCamera.Pos.x  <= Pos.x + w && 
                Play.y + worldCamera.Pos.y >= Pos.y && Play.y + worldCamera.Pos.y <= Pos.y + h) {
                return true;
            }
        }
        return false;
    }
}
