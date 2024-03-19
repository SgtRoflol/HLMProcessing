class Player{
    float angle;
    float x;
    float y;
    int weapInd = 0;
    int size;
    PVector Origin;//Ursprung der Waffen
    Wall[] Waende; //Array mit allen Wänden
    Weapon[] Waffen; //Array mit allen Waffen
    int hp;
    Projectile[] EnemyProj; //Array mit allen Gegnerprojektilen
    PImage img;
    PImage dead;
    boolean isAlive;
    int sway;
    
    Player(Wall[] Waende) {
        //Position auf Bildschirmmitte legen und Farbe festlegen
        isAlive = true;
        hp = 30;
        x = width / 2;
        y = height / 2;
        Origin = new PVector(worldCamera.Pos.x + height / 2,worldCamera.Pos.y + height / 2);    
        farbe = color(255,0,0);
        size = 50;
        this.Waende = Waende;
        img = loadImage("Character.png");
        dead = loadImage("dead.png");
        
        Waffen = new Weapon[3]; //Arraylänge definieren
        //Konstruktor -> String Name, int maxAmmo, int projSpeed, 
        //int cad,float reloadTime, PVector Origin, boolean isHostile, Wall[] Walls
        Waffen[0] = new Weapon("Waffe",30,20,5,50,Origin,false,CurScene.getWalls(),10);
        Waffen[1] = new Weapon("Waffe2",10,20,30,60,Origin,false,CurScene.getWalls(),15);
        Waffen[2] = new Weapon("Waffe3",5,40,70,100,Origin,false,CurScene.getWalls(),30); 
    }
    
    
    void render() {
        //Spieler zeichnen, aktuelle fill Farbe speichern und später zurücksetzen
        if (hp <= 0) {
            hp = 0;
            farbe = (color(0));
            isAlive = false;
        }
        //Wenn Spieler tot ist, wird das Bild um 180° gedreht und das Bild "dead" wird gezeichnet
        if (!isAlive) {
            imageMode(CENTER);
            pushMatrix();
            rotate(PI);
            image(dead,0,0,size * 2,size * 2);
            popMatrix();
            return;
        }
        sway = 30;
        //Wenn eine Taste gedrückt wird, wird sway auf 100 gesetzt ansonten auf 30
        for (boolean b : keys) {
            if (b) {
                sway = 100;
            }
        }
        //überprüfen ob der Spieler getroffen wurde
        checkHit();
        
        rectMode(CENTER);
        imageMode(CENTER);
        //Spielerrechteck zeichnen
        image(img,0,0,size * 1.5,size * 1.5);
        //Waffen Ursprung auf Spieler setzen
        for (Weapon Waffe : Waffen) {
            Waffe.Origin = new PVector(worldCamera.Pos.x + width / 2,worldCamera.Pos.y + height / 2);
        }
        
    }
    
    //Waffen rendern
    void renderWeapons() {
        for (Weapon Waffe : Waffen) {
            Waffe.render();
            //Waffe auf Mausposition setzen
            Waffe.setTarget(worldCamera.Pos.x + mouseX + int(random( -sway,sway)),worldCamera.Pos.y + mouseY + int(random( -sway,sway)));     
        }
    }
    
    //dreht den Spieler zur Maus
    void rot() {
        pushMatrix();
        if (isAlive) {
            //Spielerrechteck zur Maus hindrehen
            angle = atan2(x - mouseX, y - mouseY);
        }
        translate(x, y);
        rotate( -angle - HALF_PI);
        render();
        popMatrix();
    }
    
    
    
    void switchWeapons() {
        // Akutelle Waffe wird auf Waffe aus Array an allen Waffen gesetzt, somit können diese gewechselt werden
        if (key == 'e') {
            if (weapInd == Waffen.length - 1) {
                curWeapon.isShooting = false;
                weapInd = 0;
                curWeapon = Waffen[weapInd];
            }
            else{
                curWeapon.isShooting = false;
                curWeapon = Waffen[weapInd + 1];
                weapInd++;
            }
        }
        if (key == 'q') {
            if (weapInd == 0) {
                curWeapon.isShooting = false;
                weapInd = Waffen.length - 1;
                curWeapon = Waffen[weapInd];  
            }
            else{
                curWeapon.isShooting = false;
                curWeapon = Waffen[weapInd - 1];
                weapInd--;
            }
        }
        
    }
    
    //Überprüft ob der Spieler mit einer Wand kollidiert
    boolean getCollision(PVector Pos) {
        
        for (Wall Wall : Waende) {
            //Wenn der Spieler mit einer Wand kollidieren würde,wird true zurückgegeben
            if (x + Pos.x + size / 2 >= Wall.Pos.x && x + Pos.x - size / 2 <= Wall.Pos.x + Wall.w && 
                y + Pos.y + size / 2 >= Wall.Pos.y && y + Pos.y - size / 2 <= Wall.Pos.y + Wall.h) {
                return true;
            } 
        }
        
        return false;
    }
    
    //Gegnerprojektile setzen
    void setProjectiles(Projectile[] Bullets) {
        EnemyProj = Bullets;
    }
    
    //Wände setzen
    void setWalls(Wall[] Walls) {
        this.Waende = Walls;
        for (Weapon Waffe : Waffen) {
            Waffe.setWalls(Walls);
        }
    }
    
    //Überprüft ob der Spieler getroffen wurde
    void checkHit() {
        for (Projectile Bullet : EnemyProj) {
            if (Bullet.isActive) {
                //Distanz zwischen Spieler und Projektil berechnen
                float disX = worldCamera.Pos.x + width / 2 - Bullet.Pos.x;
                float disY = worldCamera.Pos.y + height / 2 - Bullet.Pos.y;
                //Wenn die Distanz kleiner als der Radius des Spielers ist, wird der Spieler getroffen
                if (sqrt(sq(disX) + sq(disY)) < size / 2 && Bullet.isActive) {
                    //Spieler verliert HP und Projektil wird zurückgesetzt
                    hp = hp - Bullet.damage;
                    Bullet.init();
                    //Wenn der Spieler tot ist, wird ein Sound gesendet
                    if (hp <= 0) {
                        int sound = int(random(0,4));
                        osc.send(hitMessages[sound], meineAdresse);
                    }
                }
            }
        }
    }
}
