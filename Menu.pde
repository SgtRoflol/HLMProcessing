class Menu{
    Button[] Knoepfe;
    PImage Background;
    
    Menu() {
        Knoepfe = new Button[3];
        //Button to start game -> -> PVector _Pos, int _w, int _h, color _farbe, String _Tex
        Knoepfe[0] = new Button(new PVector(width / 2 - 100, height / 2 - 100), 200, 50, color(255, 0, 0), "New Game");
        //button to load saved progress
        Knoepfe[1] = new Button(new PVector(width / 2 - 100, height / 2), 200, 50, color(0, 255, 0), "Load Game");
        //button to exit game
        Knoepfe[2] = new Button(new PVector(width / 2 - 100, height / 2 + 100), 200, 50, color(0, 0, 255), "Exit Game");
        
        Background = loadImage("Background2.png");
    }
    
    void render() {
        image(Background, 0, 0, width, height);
        for (int i = 0; i < Knoepfe.length; i++) {
            Knoepfe[i].render();
        }
    }
    
    void buttonAction() {
        if (Knoepfe[0].mouseOver()) {
            //load firstlevel
            menu = false;
            curLevel = 1;
            loadScene(PackagePath, curLevel);
        }
        if (Knoepfe[1].mouseOver()) {
            //load savedprogress
            menu = false;
            loadScene(PackagePath, savedLevel);
        }
        if (Knoepfe[2].mouseOver()) {
            exit();
            
        }
    }
}
