Camera worldCamera; //Kamera
Player Play; //Spieler
Weapon curWeapon; //Aktuelle Waffe
Scene CurScene;
Hud Overlay;
Projectile[] PlayerProj; //Alle Spielerprojektile
Projectile[] EnemyProj;


void setup() {
    size(800, 800,P2D);
    //Framerate und Anti-Aliasing setzen
    smooth(4);
    frameRate(60);
    CurScene = new Scene("Walls.json","Enemies.json");
    worldCamera = new Camera(); // Worldcamera wird genutzt, um Level größer als der Screen erstellen zu können
    Play = new Player(CurScene.getWalls()); //Spieler instanziieren
    curWeapon = Play.Waffen[0]; // Aktuelle Waffe
    PlayerProj = new Projectile[0];
    for (Weapon Waffe : Play.Waffen) {
        PlayerProj = (Projectile[])concat(PlayerProj, Waffe.getBullets());
    }
    EnemyProj = new Projectile[0];
    for (Enemy Gegner : CurScene.Gegners) {
        EnemyProj = (Projectile[])concat(EnemyProj, Gegner.Waffe.getBullets());
    }
    
    Play.setProjectiles(EnemyProj);
    Overlay = new Hud();
    CurScene.setPlayer(Play);
    
}

void draw() {
    background(255);
    //Alles andere muss nach der Worldcamera gezeichnet werden!
    pushMatrix();
    translate( -worldCamera.Pos.x, -worldCamera.Pos.y); //Worldcam verschiebt Achsen um Bewegungswert
    worldCamera.draw();
    Play.renderWeapons();
    curWeapon.shoot();
    CurScene.render();
    //WorldCamera Ende
    popMatrix();
    Overlay.render(); 
    fill(255);
    //Spieler zur Maus drehen
    Play.rot();   
    println(frameRate);
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
    //werden, umdauerladen und Schießen zu vermeiden
    if (!curWeapon.isShooting) {
        curWeapon.reload();
    }
    
    if (key == 'g') {
        worldCamera.Pos.x = 0;
        worldCamera.Pos.y = 0;
        CurScene.init();
    }
}
