import oscP5.*;
import netP5.*;

//OSC importieren und einrichten um mit Max8 zu kommunizieren
OscP5 osc = new OscP5(this, 12346);
NetAddress meineAdresse = new NetAddress("127.0.0.1", 12346);
//OscMessages für Schüsse, Treffer und Nachladen
OscMessage shotMessage = new OscMessage("shot");
OscMessage enemyShotMessage = new OscMessage("enemyShot");
OscMessage reloadMessage = new OscMessage("reload");
//OscMessages für Treffer
OscMessage[] hitMessages = new OscMessage[4];

//Json um Spielstand zu speichern und laden zu können
JSONObject json;
JSONObject save;


Camera worldCamera; //Kamera
boolean[] keys = new boolean[160]; //Tasten der Tastatur
Player Play; //Spieler
Weapon curWeapon; //Aktuelle Waffe
Scene CurScene; //Aktuelles Level
Hud Overlay; //Overlay 
Projectile[] PlayerProj; //Alle Spielerprojektile
Projectile[] EnemyProj; //Alle Gegnerprojektile
int curLevel; //Index des aktuellen Levels
int savedLevel; //Gespeicherter Levelstand
String PackagePath; //Pfad zum Package mit den einzelnen Leveln
Goal Ziel; //Ziel nach abgeschlossenem Level
PImage background; //Hintergrundbild für das Level
boolean menu; //True wenn Menü angezeigt wird
boolean finished; //True wenn Spiel beendet wurde
Menu startScreen; //Startbildschirm


void setup() {
    save = new JSONObject(); //Spielstand speichern
    json = loadJSONObject("save.json"); //Spielstand laden
    savedLevel = json.getInt("level"); //Gespeicherten Levelstand laden
    hitMessages[0] = new OscMessage("hit"); //OscMessages für Treffer
    hitMessages[1] = new OscMessage("hit1");
    hitMessages[2] = new OscMessage("hit2");
    hitMessages[3] = new OscMessage("hit3");
    startScreen = new Menu(); //Startbildschirm
    menu = true; //Menü wird zu Beginn angezeigt
    Ziel = new Goal(width / 2 - 70 ,height / 2, 180,100); //Ziel
    curLevel = 1; //Startlevel
    PackagePath = sketchPath(); //Pfad zum Package ist der Pfad des Sketches
    size(800, 800,P2D); //Fenstergröße
    frameRate(60); //Framerate auf 60 setzen
    background = loadImage("background.png"); //Hintergrundbild laden
}

void draw() {
    //Wenn das Spiel beendet wurde, wird eine Nachricht angezeigt
    if (finished) {
        background(0); 
        textSize(50); 
        textAlign(CENTER);
        fill(255);
        text("Congratulations,", width / 2, height / 2);
        text("you have finished the game!", width / 2, height / 2 + 50);
        text("Press ESC to restart", width / 2, height / 2 + 100);
        textAlign(LEFT);
        return;
    }
    //Hauptlogik des Spiels wird durchgeführt wenn das Menü nicht angezeigt wird und das Spiel nicht beendet wurde
    if (!menu && !finished) {
        worldCamera.screenshake(); //Kamerawackeln wenn Spieler schiesst
        background(255); //Hintergrundfarbe
        //Alles andere muss nach der Worldcamera gezeichnet werden!
        pushMatrix();
        translate( -worldCamera.Pos.x, -worldCamera.Pos.y); //Worldcam verschiebt Achsen um Bewegungswert um so das Level zu verschieben
        worldCamera.draw(); //Verschiebung der Kamerapositon
        
        //Hintergrundbild aus Texturen erstellen
        for (int i = -1000; i < 5000; i = i + 56) {
            for (int j = -1000; j < 5000; j = j + 56) {
                image(background,i,j,56,56);
            }
        }
        
        //Aktuelles Level zeichnen
        CurScene.render();
        //Spielerwaffen zeichnen
        Play.renderWeapons();
        //Falls der Spieler lebt, kann er schiessen
        if (Play.isAlive) {
            curWeapon.shoot();
        }
        //Wenn alle Gegner besiegt wurden, wird das Ziel gezeichnet
        Ziel.render();
        popMatrix();
        //WorldCamera Ende
        Overlay.render(); 
        fill(255);
        //Spieler zur Maus drehen
        Play.rot();  
        
        if (Ziel.playerOnTop()) {
            loadScene(PackagePath, ++curLevel);
        }
    }
    else{
        //Startbildschirm wird gezeichnet
        startScreen.render();
        if (CurScene != null) {
            //Wenn ein Level geladen ist, wird ein Zusatztext angezeigt
            textSize(30);
            textAlign(CENTER);
            fill(255);
            text("ESC to return to game", width / 2, 200);
            textAlign(LEFT);
            fill(0);
        }
    }
}
void mousePressed() {
    //Wenn das Menü angezeigt wird, wird die Aktion des Startbildschirms ausgeführt
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
    keys[keyCode] = true;
    
    if (keyCode == ESC) {
        //key = 0 wird gesetzt, damit der Sketch nicht schließt
        key = 0;
        if (!finished) {
            if (!menu) {
                //wird das Menü angezeigt, wird das aktuelle Level gespeichert
                savedLevel = curLevel;
                menu = true;
            }
            else if (CurScene != null) {
                //ist das Menü angezeigt und ein Level geladen, wird das Level fortgesetzt
                menu = false;
            }
        }
        if (finished) {
            //wenn das Spiel beendet wurde, wird das Spiel zurückgesetzt
            curLevel = 1;
            savedLevel = 1;
            finished = false;
            menu = true;
            CurScene = null;    
        }
    }
    if (!menu) {
        //Waffen Wechseln und Nachladen
        Play.switchWeapons(); 
        if (Play.isAlive) {
            if (!curWeapon.isShooting) {
                curWeapon.reload();
            }
        }
        //Wenn der Spieler tot ist, wird das Level neu geladen
        else{
            if (key == 'r') {
                initScene();
            }
        }
        
    }
}

void keyReleased() {
    //Tasten werden auf false gesetzt, wenn sie losgelassen werden
    keys[keyCode] = false;
}

//alle Projektile werden in einem Array zusammengefasst
void getEnemyProj() {
    //Leeres Array damit keine Fehler auftreten
    EnemyProj = new Projectile[0];
    for (Enemy Gegner : CurScene.Gegners) {
        //Projektile der Gegner werden in das Array EnemyProj angehängt
        EnemyProj = (Projectile[])concat(EnemyProj, Gegner.Waffe.getBullets());
    }
}



void loadScene(String path, int index) {
    String LevelPath = path + "/data/Packages/Package1/Level" + str(index) + "/"; //Pfad zum Level
    //Neues Level wird erstellt
    CurScene = new Scene(LevelPath + "Walls.json",LevelPath + "Enemies.json");
    worldCamera = new Camera(); // Worldcamera wird genutzt,um Level größer als der Screen erstellen zu können
    Play = new Player(CurScene.getWalls()); //Spieler instanziieren
    curWeapon = Play.Waffen[0]; // Aktuelle Waffe
    PlayerProj = new Projectile[0]; //Projektile des Spielers werden zurückgesetzt
    curLevel = index;//Aktueller Level index im Package
    save.setInt("level", curLevel); //Gespeicherter Levelstand wird aktualisiert
    saveJSONObject(save, "data/save.json");
    initScene(); //Szene wird initialisiert
}

void initScene() {
    if (!finished) {
        //Kamera wird zurückgesetzt
        worldCamera.Pos.x = 0;
        worldCamera.Pos.y = 0;
        Play.hp = 30; //Lebenspunkte des Spielers
        CurScene.init(); //Szene wird initialisiert
        Play.isAlive = true; //Spieler ist am Leben
        CurScene.enemyAmount = CurScene.Gegners.length; //Anzahl der Gegner im Level
        
        for (Weapon Waffe : Play.Waffen) {
            PlayerProj = (Projectile[])concat(PlayerProj, Waffe.getBullets()); //Projektile des Spielers werden in das Array PlayerProj angehängt
            Waffe.ammo = Waffe.maxAmmo; //Munition der Spielerwaffen wird auf Maximalwert gesetzt
        }
        getEnemyProj(); //Projektile der Gegner werden in das Array EnemyProj angehängt
        Play.setProjectiles(EnemyProj); //Projektile der Gegner werden dem Spieler übergeben
        Overlay = new Hud(); //Overlay wird erstellt
        CurScene.setPlayer(Play); //Spieler wird dem Level übergeben
        Play.setWalls(CurScene.getWalls()); //Wände des Levels werden dem Spieler übergeben
    }
}
