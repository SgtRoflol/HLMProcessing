class Button{
    PVector Pos;
    int w;
    int h;
    color farbe;
    String Text;
    
    //Constructor for button        
    Button(PVector _Pos, int _w, int _h, color _farbe, String _Text) {
        Pos = _Pos;
        w = _w;
        h = _h;
        farbe = _farbe;
        Text = _Text;
    }
    
    //render the button
    void render() {
        rectMode(CORNER);
        fill(farbe);
        rect(Pos.x, Pos.y, w, h);
        fill(0);
        textSize(20);
        textMode(CENTER);
        text(Text, Pos.x + w / 4, Pos.y + h / 4,w,h);
    }
    
    
    boolean mouseOver() {
        if (mouseX >= Pos.x && mouseX <= Pos.x + w && 
            mouseY >= Pos.y && mouseY <= Pos.y + h) {
            return true;
        } else{
            return false;
        }
    }
}
