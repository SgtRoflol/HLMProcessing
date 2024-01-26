Camera worldCamera; //Kamera
Player Play; //Spieler
Weapon curWeapon; //Aktuelle Waffe
Scene CurScene;
Hud Overlay;
Projectile[] PlayerProj;


void setup() {
    size(800, 800,P2D);
    //Framerate und Anti-Aliasing setzen
    smooth(4);
    frameRate(60);
    CurScene = new Scene();
    worldCamera = new Camera(); // Worldcamera wird genutzt, um Level größer als der Screen erstellen zu können
    Play = new Player(); //Spieler instanziieren
    curWeapon = Play.Waffen[0]; // Aktuelle Waffe
    PlayerProj = new Projectile[0];
    for (Weapon Waffe : Play.Waffen) {
        PlayerProj = (Projectile[])concat(PlayerProj, Waffe.getBullets());
    }
    Overlay = new Hud();
    Play.getWalls(CurScene.Waende);
    
}

void draw() {
    background(255);
    //Alles andere muss nach der Worldcamera gezeichnet werden!
    pushMatrix();
    translate( -worldCamera.pos.x, -worldCamera.pos.y); //Worldcam verschiebt Achsen um Bewegungswert
    worldCamera.draw();
    CurScene.render();
    Play.renderWeapons();
    curWeapon.shoot();
    //WorldCamera Ende
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
    Play.switchWeapons();
    
    //Es kann nur nachgeladen werden, wenn geschossen wird, ausserdem kann einige Zeit nicht geschossen
    //werden, um dauerladen und Schießen zu vermeiden
    if (!curWeapon.isShooting) {
        curWeapon.reload();
    }
}
