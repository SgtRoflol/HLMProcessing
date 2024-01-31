class Wall{
    PVector Pos;
    int w;
    int h;
    
    Wall(PVector Pos, int w, int h) {
        this.Pos = Pos;
        this.w = w;
        this.h = h;
    }
    void render() {
        fill(0,255,0);
        rectMode(CORNER);
        rect(Pos.x,Pos.y,w,h);
        fill(0);
        stroke(0);
        line(Pos.x,Pos.y,Pos.x + w,Pos.y + h);
        line(Pos.x,Pos.y + h,Pos.x + w,Pos.y);
        
    }
    
    boolean isOnScreen() {
        if (Pos.x > worldCamera.Pos.x + width || Pos.x + w < worldCamera.Pos.x) {
            return false;
        }    
        if (Pos.y > worldCamera.Pos.y + height || Pos.y + h < worldCamera.Pos.y) {
            return false;
        }
        return true;
    }
    
    
}
