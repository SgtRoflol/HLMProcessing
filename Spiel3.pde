Camera worldCamera; //Kamera
Player Play; //Spieler
Weapon[] Waffen; //Array mit allen Waffen
Weapon curWeapon; //Aktuelle Waffe
int weapInd; //Index der aktuellen Waffe, wird benötigt um wechseln zu können
Wall[] Waende;
Hud Overlay;


void setup() {
    Waende = new Wall[3];
    Waende[0] = new Wall(new PVector(700,200),300,100);
    Waende[1] = new Wall(new PVector(200,600),200,70);
    Waende[2] = new Wall(new PVector(10,100),300,100);
    weapInd = 0;
    //Framerate und Anti-Aliasing setzen
    frameRate(60);
    smooth(4);
    size(800, 800,P2D);
    worldCamera = new Camera(); // Worldcamera wird genutzt, um Level größer als der Screen erstellen zu können
    Play = new Player(); //Spieler instanziieren
    Waffen = new Weapon[3]; //Arraylänge definieren
    Waffen[0] = new Weapon("Waffe",30,10,5,50);// Konstruktor -> String Name, int maxAmmo, int projSpeed, int cad
    Waffen[1] = new Weapon("Waffe2",10,20,30,60);
    Waffen[2] = new Weapon("Waffe3",5,40,70,100); 
    curWeapon = Waffen[0]; // Aktuelle Waffe
    Overlay = new Hud();
    for (Weapon Waffe : Waffen) {
        Waffe.getWalls(Waende);
    }
}

void draw() {
    background(255);
    //Alles andere muss nach der Worldcamera gezeichnet werden!
    pushMatrix();
    translate( -worldCamera.pos.x, -worldCamera.pos.y); //Worldcam verschiebt Achsen um Bewegungswert
    worldCamera.draw();
    //Alle Waffen/Alle AKTIVEN Projektile aller Waffen rendern
    for (Weapon Waffe : Waffen) {
        Waffe.render();
    }
    //Aktuelle Waffe abfeuern falls möglich
    curWeapon.shoot();
    for (Wall Wand : Waende) {
        Wand.render();
    }
    //WorldCamera Ende
    rect(25,25,25,25);
    popMatrix();
    Overlay.render(); 
    fill(255);
    
    //Spieler zur Maus drehen
    Play.move();   
}

void mousePressed() {
    curWeapon.isShooting = true; //Wird gesetzt um beständiges Schießen bei Halten der Maustaste zu ermöglichen
}

void mouseReleased() {
    curWeapon.isShooting = false;
}

void keyPressed() {
    //Zwischen Waffen wechseln
    switchWeapons();
    
    //Es kann nur nachgeladen werden, wenn geschossen wird, ausserdem kann einige Zeit nicht geschossen
    //werden, um dauerladen und Schießen zu vermeiden
    if (!curWeapon.isShooting) {
        curWeapon.reload();
    }
}

void switchWeapons() {
    // Akutelle Waffe wird auf Waffe aus Array an allen Waffen gesetzt, somit können diese gewechselt werden
    if (key == 'e' && weapInd < Waffen.length - 1) {
        curWeapon.isShooting = false;
        curWeapon = Waffen[weapInd + 1];
        weapInd++;
    }
    if (key == 'q' && weapInd > 0) {
        curWeapon.isShooting = false;
        curWeapon = Waffen[weapInd - 1];
        weapInd--;
    }
    
}
