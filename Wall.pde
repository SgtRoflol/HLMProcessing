class Wall{
    PVector Pos;
    int w;
    int h;
    PImage img;
    
    //Konstruktor
    Wall(PVector Pos, int w, int h) {
        this.Pos = Pos;
        this.w = w;
        this.h = h;
        if (w > h) {
            img = loadImage("wallVertical.png");
        }
        else{
            img = loadImage("wallHorizontal.png");
        }
    }
    
    void render() {
        //Wand wird gezeichnet
        fill(0,255,0);
        rectMode(CORNER);
        rect(Pos.x,Pos.y,w,h);
        imageMode(CORNER);
        //Wenn die Wand breiter als hoch ist, wird das Bild so oft horizontal gezeichnet, bis die Wand vollständig bedeckt ist
        if (w > h) {
            img.resize(h,h);
            for (int i = 0; i < w; i = i + img.width) {
                if (img.width > w - i) {
                    PImage temp = img.get(0,0,w - i,img.height);
                    image(temp,Pos.x + i,Pos.y,temp.width,temp.height);
                }
                else{
                    image(img,Pos.x + i,Pos.y,img.width,img.height);
                }
                
            }
        }
        //Wenn die Wand höher als breit ist, wird das Bild so oft vertikal gezeichnet, bis die Wand vollständig bedeckt ist
        else{
            img.resize(w,w);
            for (int i = 0; i < h; i = i + img.height) {
                if (img.height > h - i) {
                    PImage temp = img.get(0,0,img.width,h - i);
                    image(temp,Pos.x,Pos.y + i,temp.width,temp.height);
                }
                else{
                    image(img,Pos.x,Pos.y + i,img.width,img.height);
                }
            }
        }
        fill(0);
        stroke(0);
        
    }
    //Methode, die prüft, ob die Wand auf dem Bildschirm ist
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
