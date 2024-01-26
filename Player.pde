class Player{
    float angle;
    float x;
    float y;
    color farbe;
    int weapInd = 0;
    
    Weapon[] Waffen; //Array mit allen Waffen
    
    Player() {
        //Position auf Bildschirmmitte legen und Farbe festlegen
        x = width / 2;
        y = height / 2;
        farbe = color(255,0,0);
        
        
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
        rect(0,0,50,50);
        fill(curcol);
        
    }
    
    void renderWeapons() {
        for (Weapon Waffe : Waffen) {
            Waffe.render();
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
}
