Camera worldCamera;
Player Play;
int ammo;
Projectile[] Bullets = new Projectile[10];


int imgX;
int imgY;


void setup() {
    ammo = 10;
    smooth(2);
    size(640, 640);
    worldCamera = new Camera();
    Play = new Player();
    for (int i = 0; i < Bullets.length; i++) {
        Bullets[i] = new Projectile(4);
    }
}

void draw() {
    background(255);
    //Alles andere muss nach der Worldcamera gezeichnet werden!
    pushMatrix();
    translate( -worldCamera.pos.x, -worldCamera.pos.y);
    worldCamera.draw();

    for (int i = 0; i < Bullets.length; i++) {
        Bullets[i].render();
    }
    //WorldCamera Ende
    rect(25,25,25,25);
    popMatrix();
    
    fill(0);
    text(ammo,100,100);
    fill(255);
    
    Play.move();
    println(Play.x);
    
    
    
}
void mouseClicked() {
    for (int i = 0; i < Bullets.length; i++) {
        if (!Bullets[i].isActive && ammo != 0) {
            Bullets[i].spawn();
            ammo--;
            break;
        }
    }
}
    
    
    void keyPressed() {
        if (key == 'r') {
            ammo = 10;
        }
    }
