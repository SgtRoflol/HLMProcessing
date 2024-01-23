Camera worldCamera;
Player Play;
Weapon Waffe;



int imgX;
int imgY;


void setup() {
    frameRate(60);
    smooth(2);
    size(640, 640);
    worldCamera = new Camera();
    Play = new Player();
    Waffe = new Weapon("Waffe",30,10,5); // Konstruktor -> String Name, int maxAmmo, int projSpeed, int cad
}

void draw() {
    background(255);
    //Alles andere muss nach der Worldcamera gezeichnet werden!
    pushMatrix();
    translate( -worldCamera.pos.x, -worldCamera.pos.y);
    worldCamera.draw();
    Waffe.render();
    Waffe.shoot();
    
    //WorldCamera Ende
    rect(25,25,25,25);
    popMatrix();
    
    fill(0);
    text(Waffe.ammo,100,100);
    fill(255);
    
    Play.move();
    
    
    
}

void mousePressed() {
    Waffe.isShooting = true;
}

void mouseReleased() {
    Waffe.isShooting = false;
}

void keyPressed() {
    Waffe.reload();
}
