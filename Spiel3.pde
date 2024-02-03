Camera worldCamera; //Kamera
boolean[] keys = new boolean[128];
Player Play; //Spieler
Weapon curWeapon; //Aktuelle Waffe
Scene CurScene;
Hud Overlay;
Projectile[] PlayerProj; //Alle Spielerprojektile
Projectile[] EnemyProj;
int curLevel;
String PackagePath;
Goal Ziel;
PImage background;


void setup() {

Ziel = new Goal(width/2-70 ,height/2, 180,100);
curLevel = 1;
PackagePath= sketchPath();
loadScene(PackagePath, curLevel);
size(800, 800,P2D);
    smooth(4);
    frameRate(60);
    background = loadImage("background.png");
}

void draw() {
    background(255);
    //Alles andere muss nach der Worldcamera gezeichnet werden!
    pushMatrix();
    translate( -worldCamera.Pos.x, -worldCamera.Pos.y); //Worldcam verschiebt Achsen um Bewegungswert
    worldCamera.draw();
    for(int i = 0; i< 1500; i = i + background.width){
        for(int j = 0; j < 1500; j = j + background.height){
            image(background,i,j,background.width,background.height);
        }
    }
    Play.renderWeapons();
    if (Play.isAlive) {
        curWeapon.shoot();
    }
    CurScene.render();
    //WorldCamera Ende
    Ziel.render();
    popMatrix();
    Overlay.render(); 
    fill(255);
    //Spieler zur Maus drehen
    Play.rot();  

if(Ziel.playerOnTop()){
    loadScene(PackagePath, ++curLevel);
}
    println("MouseX " + mouseX);
    println("MouseY " + mouseY); 
}
void mousePressed() {
    curWeapon.isShooting = true; //Wird gesetzt um beständiges Schießen bei Halten der Maustaste zu ermöglichen
}

void mouseReleased() {
    curWeapon.isShooting = false;
}

void keyPressed() {
    //Zwischen Waffen wechseln
    keys[keyCode] = true;
    Play.switchWeapons();
    
    //Es kann nur nachgeladen werden, wenn geschossen wird, ausserdem kann einige Zeit nicht geschossen
    //werden, umdauerladen und Schießen zu vermeiden
    
    if(Play.isAlive){
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
void keyReleased() {
    keys[keyCode] = false;
}

void getEnemyProj() {
    EnemyProj = new Projectile[0];
    for (Enemy Gegner : CurScene.Gegners) {
        EnemyProj = (Projectile[])concat(EnemyProj, Gegner.Waffe.getBullets());
    }
}



void loadScene(String path, int index){
    String LevelPath =path +"/data/Packages/Package1/Level"+ str(index) +"/";
    CurScene = new Scene( LevelPath+"Walls.json",LevelPath+"Enemies.json");
    worldCamera = new Camera(); // Worldcamera wird genutzt, um Level größer als der Screen erstellen zu können
    Play = new Player(CurScene.getWalls()); //Spieler instanziieren
    curWeapon = Play.Waffen[0]; // Aktuelle Waffe
    PlayerProj = new Projectile[0];
    initScene();
}

void initScene(){
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
