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
        rectMode(CENTER);
        fill(0,255,0);
        rect(Pos.x,Pos.y,w,h);
        
    }
    
    
}
