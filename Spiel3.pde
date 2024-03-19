import oscP5.*;
import netP5.*;

OscP5 osc = new OscP5(this, 12346);
NetAddress meineAdresse = new NetAddress("127.0.0.1", 12346);
OscMessage shotMessage = new OscMessage("shot");
OscMessage enemyShotMessage = new OscMessage("enemyShot");
OscMessage reloadMessage = new OscMessage("reload");

OscMessage[] hitMessages = new OscMessage[4];

Camera worldCamera; //Kamera
boolean[] keys = new boolean[160];
Player Play; //Spieler
Weapon curWeapon; //Aktuelle Waffe
Scene CurScene;
Hud Overlay;
Projectile[] PlayerProj; //Alle Spielerprojektile
Projectile[] EnemyProj;
int curLevel;
int savedLevel;
String PackagePath;
Goal Ziel;
PImage background;
boolean menu;
boolean finished;
Menu startScreen;


void setup() {
    hitMessages[0] = new OscMessage("hit");
    hitMessages[1] = new OscMessage("hit1");
    hitMessages[2] = new OscMessage("hit2");
    hitMessages[3] = new OscMessage("hit3");
    startScreen = new Menu();
    menu = true;
    Ziel = new Goal(width / 2 - 70 ,height / 2, 180,100);
    curLevel = 1;
    savedLevel = 2;
    PackagePath = sketchPath();
    size(800, 800,P2D);
    frameRate(60);
    background = loadImage("background.png");
}

void draw() {
    if (finished) {
        background(0);
        textSize(50);
        textAlign(CENTER);
        text("Congratulations,", width / 2, height / 2);
        text("you have finished the game!", width / 2, height / 2 + 50);
        textAlign(LEFT);
        return;
    }
    if (!menu && !finished) {
        worldCamera.screenshake();
        background(255);
        //Alles andere muss nach der Worldcamera gezeichnet werden!
        pushMatrix();
        translate( -worldCamera.Pos.x, -worldCamera.Pos.y); //Worldcam verschiebt Achsen um Bewegungswert
        worldCamera.draw();
        
        for (int i = -1000; i < 5000; i = i + background.width) {
            for (int j = -1000; j < 5000; j = j + background.height) {
                image(background,i,j,background.width,background.height);
            }
        }
        CurScene.render();
                Play.renderWeapons();
        if (Play.isAlive) {
            curWeapon.shoot();
        }
        //WorldCamera Ende
        Ziel.render();
        popMatrix();
        Overlay.render(); 
        fill(255);
        //Spieler zur Maus drehen
        Play.rot();  
        
        if (Ziel.playerOnTop()) {
            loadScene(PackagePath, ++curLevel);
        }
    }
    else{
        startScreen.render();
        if (CurScene != null) {
            textSize(30);
            textAlign(CENTER);
            text("ESC to return to game", width / 2, height - 200);
            textAlign(LEFT);
        }
    }
}
void mousePressed() {
    if (menu) {
        startScreen.buttonAction();
    }
    else{
        curWeapon.isShooting = true; //Wird gesetzt um beständiges Schießen bei Halten der Maustaste zu ermöglichen
    }
}

void mouseReleased() {
    if (!menu) {
        curWeapon.isShooting = false;
    }
    
}

void keyPressed() {
    //Zwischen Waffen wechseln
    keys[keyCode] = true;
    
    if (keyCode == ESC) {
        key = 0;
        if (!menu) {
            savedLevel = curLevel;
            menu = true;
        }
        else if (CurScene != null) {
            menu = false;
        }
    }
    if (!menu) {
        Play.switchWeapons(); 
        
        if (Play.isAlive) {
            if (!curWeapon.isShooting) {
                curWeapon.reload();
            }
        }
        else{
            if (key == 'r') {
                initScene();
            }
        }
        
        if (key == 'k') {
            loadScene(PackagePath, ++curLevel);
        }
    }
}
void keyReleased() {
    keys[keyCode] = false;
}

void getEnemyProj() {
    EnemyProj = new Projectile[0];
    for (Enemy Gegner : CurScene.Gegners) {
        EnemyProj = (Projectile[])concat(EnemyProj, Gegner.Waffe.getBullets());
    }
}



void loadScene(String path, int index) {
    String LevelPath = path + "/data/Packages/Package1/Level" + str(index) + "/";
    CurScene = new Scene(LevelPath + "Walls.json",LevelPath + "Enemies.json");
    worldCamera = new Camera(); // Worldcamera wird genutzt,um Level größer als der Screen erstellen zu können
    Play = new Player(CurScene.getWalls()); //Spieler instanziieren
    curWeapon = Play.Waffen[0]; // Aktuelle Waffe
    PlayerProj = new Projectile[0];
    curLevel = index;
    initScene();
}

void initScene() {
    if (!finished) {
        worldCamera.Pos.x = 0;
        worldCamera.Pos.y = 0;
        Play.hp = 30;
        CurScene.init();
        Play.isAlive = true;
        CurScene.enemyAmount = CurScene.Gegners.length;
        
        for (Weapon Waffe : Play.Waffen) {
            PlayerProj = (Projectile[])concat(PlayerProj, Waffe.getBullets());
            Waffe.ammo = Waffe.maxAmmo;
        }
        getEnemyProj();
        Play.setProjectiles(EnemyProj);
        Overlay = new Hud();
        CurScene.setPlayer(Play);
        Play.setWalls(CurScene.getWalls());
    }
}
