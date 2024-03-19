class Menu{
    Button[] Knoepfe;
    PImage Background;
    
    Menu() {
        Knoepfe = new Button[3];
        //Button to start game -> -> PVector _Pos, int _w, int _h, color _farbe, String _Tex
        Knoepfe[0] = new Button(new PVector(width / 2 - 100, height / 2 - 100), 200, 50, color(31, 77, 31), "New Game");
        //button to load saved progress
        Knoepfe[1] = new Button(new PVector(width / 2 - 100, height / 2), 200, 50, color(31, 77, 31), "Load Game");
        //button to exit game
        Knoepfe[2] = new Button(new PVector(width / 2 - 100, height / 2 + 100), 200, 50, color(31, 77, 31), "Exit Game");
        
        Background = loadImage("Background2.png");
    }
    
    void render() {
        //Zeichnet das Menü
        imageMode(CORNER);
        image(Background, 0, 0, 800, 800);
        //Zeichnet die Buttons
        for (int i = 0; i < Knoepfe.length; i++) {
            Knoepfe[i].render();
        }
    }
    
    void buttonAction() {
        //Wenn der Button gedrückt wird, wird das Spiel gestartet
        if (Knoepfe[0].mouseOver()) {
            //load firstlevel
            menu = false;
            curLevel = 1;
            savedLevel = 1;
            loadScene(PackagePath, curLevel);
        }
        //Wenn der Button gedrückt wird, wird das Spiel geladen
        if (Knoepfe[1].mouseOver()) {
            //load savedprogress
            loadScene(PackagePath, savedLevel);
            menu = false;
        }
        //Wenn der Button gedrückt wird, wird das Spiel beendet
        if (Knoepfe[2].mouseOver()) {
            exit();
            
        }
    }
}
