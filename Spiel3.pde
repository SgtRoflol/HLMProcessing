Camera worldCamera;
Player Play;
Weapon[] Waffen;
Weapon curWeapon;
int weapInd;


void setup() {
    weapInd = 0;
    frameRate(60);
    smooth(4);
    size(640, 640);
    worldCamera = new Camera(); // Worldcamera wird genutzt, um Level größer als der Screen erstellen zu können
    Play = new Player();
    Waffen = new Weapon[3];
    Waffen[0] = new Weapon("Waffe",30,10,5,50);// Konstruktor -> String Name, int maxAmmo, int projSpeed, int cad
    Waffen[1] = new Weapon("Waffe2",10,20,30,60);
    Waffen[2] = new Weapon("Waffe3",5,40,70,100); 
    curWeapon = Waffen[weapInd]; // Aktuelle Waffe
}

void draw() {
    background(255);
    //Alles andere muss nach der Worldcamera gezeichnet werden!
    pushMatrix();
    translate( -worldCamera.pos.x, -worldCamera.pos.y); //Worldcam verschiebt Achsen um Bewegungswert
    worldCamera.draw();
    for (int i = 0; i < Waffen.length; i++) {
        Waffen[i].render();
    }
    curWeapon.shoot();
    
    //WorldCamera Ende
    rect(25,25,25,25);
    popMatrix();
    
    fill(0);
    //Zeigt Waffenname und Munition
    textSize(35);
    
    text(curWeapon.ammo,30,40);
    if (curWeapon.cooldown != 0) {
        fill(255,0,0);
    }
    text(curWeapon.Name,30,70);
    fill(255);
    
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
        curWeapon = Waffen[weapInd + 1];
        weapInd++;
    }
    if (key == 'q' && weapInd > 0) {
        curWeapon = Waffen[weapInd - 1];
        weapInd--;
    }
    
}
