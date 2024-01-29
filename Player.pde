class Player{
    float angle;
    float x;
    float y;
    color farbe;
    int weapInd = 0;
    int size;
    Wall closestWall;
    PVector Origin;
    Wall[] Waende;
    Weapon[] Waffen; //Array mit allen Waffen
    
    Player() {
        //Position auf Bildschirmmitte legen und Farbe festlegen
        x = width / 2;
        y = height / 2;
        farbe = color(255,0,0);
        size = 50;
        Origin = new PVector(worldCamera.pos.x + height / 2,worldCamera.pos.y + height / 2);           
        
        Waffen = new Weapon[3]; //Arraylänge definieren
        Waffen[0] = new Weapon("Waffe",30,10,5,50);// Konstruktor -> String Name, int maxAmmo, int projSpeed, int cad
        Waffen[1] = new Weapon("Waffe2",10,20,30,60);
        Waffen[2] = new Weapon("Waffe3",5,40,70,100); 
    }
    
    
    void render() {
        //Spieler zeichnen, aktuelle fill Farbe speichern und später zurücksetzen
        color curcol = g.fillColor;
        fill(farbe);
        rectMode(CENTER);
        rect(0,0,size,size);
        fill(curcol);
        println(getCollision(worldCamera.pos));
        
    }
    
    void renderWeapons() {
        for (Weapon Waffe : Waffen) {
            Waffe.render();
            Waffe.setTarget(worldCamera.pos.x + mouseX,worldCamera.pos.y + mouseY);
            
        }
    }
    
    void move() {
        //Spielerrechteck zur Maus hindrehen
        pushMatrix();
        angle = atan2(x - mouseX, y - mouseY);
        translate(x, y);
        rotate( -angle - HALF_PI);
        render();
        popMatrix();
    }
    
    void getWalls(Wall[] Waende) {
        for (Weapon Waffe : Waffen) {
            Waffe.getWalls(Waende);
        }
        this.Waende = Waende;
    }
    
    void switchWeapons() {
        // Akutelle Waffe wird auf Waffe aus Array an allen Waffen gesetzt, somit können diese gewechselt werden
        if (key == 'e') {
            if (weapInd == Waffen.length - 1) {
                curWeapon.isShooting = false;
                weapInd = 0;
                curWeapon = Waffen[weapInd];
            }
            else{
                curWeapon.isShooting = false;
                curWeapon = Waffen[weapInd + 1];
                weapInd++;
            }
        }
        if (key == 'q') {
            if (weapInd == 0) {
                curWeapon.isShooting = false;
                weapInd = Waffen.length - 1;
                curWeapon = Waffen[weapInd];  
            }
            else{
                curWeapon.isShooting = false;
                curWeapon = Waffen[weapInd - 1];
                weapInd--;
            }
        }
        
    }
    
    boolean getCollision(PVector Pos) {
        
        for (Wall Wand : Waende) {
            for (Wall Wall : Waende) {
                if (x + Pos.x + size / 2 >= Wall.Pos.x && x + Pos.x - size / 2 <= Wall.Pos.x + Wall.w && 
                    y + Pos.y + size / 2 >= Wall.Pos.y && y + Pos.y - size / 2 <= Wall.Pos.y + Wall.h) {
                    closestWall = Wand;
                    return true;
                } 
            }
        }
        return false;
    }
}
