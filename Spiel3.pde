Camera worldCamera;
Player Play;
Weapon[] Waffen;
Weapon curWeapon;
int weapInd;



int imgX;
int imgY;


void setup() {
    weapInd = 0;
    frameRate(60);
    smooth(2);
    size(640, 640);
    worldCamera = new Camera();
    Play = new Player();
    Waffen = new Weapon[3];
    Waffen[0] = new Weapon("Waffe",30,10,5);
    Waffen[1] = new Weapon("Waffe2",10,20,30);
    Waffen[2] = new Weapon("Waffe3",1,40,100); // Konstruktor -> String Name, int maxAmmo, int projSpeed, int cad
    curWeapon = Waffen[weapInd];
}

void draw() {
    background(255);
    //Alles andere muss nach der Worldcamera gezeichnet werden!
    pushMatrix();
    translate( -worldCamera.pos.x, -worldCamera.pos.y);
    worldCamera.draw();
    for (int i = 0; i < Waffen.length; i++) {
        Waffen[i].render();
    }
    curWeapon.shoot();
    
    //WorldCamera Ende
    rect(25,25,25,25);
    popMatrix();
    
    fill(0);
    text(curWeapon.ammo,100,100);
    text(curWeapon.Name,100,80);
    fill(255);
    
    Play.move();
    
    
    
}

void mousePressed() {
    curWeapon.isShooting = true;
}

void mouseReleased() {
    curWeapon.isShooting = false;
}

void keyPressed() {
    if (key == 'e' && weapInd < Waffen.length - 1) {
        curWeapon = Waffen[weapInd + 1];
        weapInd++;
    }
    if (key == 'q' && weapInd > 0) {
        curWeapon = Waffen[weapInd - 1];
        weapInd--;
    }
    
    if (!curWeapon.isShooting) {
        curWeapon.reload();
    }
}
