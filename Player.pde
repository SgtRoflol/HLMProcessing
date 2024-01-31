class Player{
    float angle;
    float x;
    float y;
    color farbe;
    int weapInd = 0;
    int size;
    PVector Origin;
    Wall[] Waende;
    Weapon[] Waffen; //Array mit allen Waffen
    int hp;
    Projectile[] EnemyProj;
    PImage img;
    PImage dead;
    boolean isAlive;
    
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
        Waffen[0] = new Weapon("Waffe",30,15,5,50,Origin,false,CurScene.getWalls(),10);
        Waffen[1] = new Weapon("Waffe2",10,20,30,60,Origin,false,CurScene.getWalls(),10);
        Waffen[2] = new Weapon("Waffe3",5,40,70,100,Origin,false,CurScene.getWalls(),30); 
    }
    
    
    void render() {
        //Spieler zeichnen, aktuelle fill Farbe speichern und später zurücksetzen
        if (hp <= 0) {
            hp = 0;
            farbe = (color(0));
            isAlive = false;
        }
        if (!isAlive) {
            imageMode(CENTER);
            image(dead,0,0,size * 2,size * 2);
            return;
        }
        
        checkHit();
        color curcol = g.fillColor;
        fill(farbe);
        rectMode(CENTER);
        imageMode(CENTER);
        image(img,0,0,size * 1.5,size * 1.5);
        //rect(0,0,size,size);
        fill(curcol);
        for (Weapon Waffe : Waffen) {
            Waffe.Origin = new PVector(worldCamera.Pos.x + width / 2,worldCamera.Pos.y + height / 2);
        }
        
    }
    
    void renderWeapons() {
        for (Weapon Waffe : Waffen) {
            Waffe.render();
            Waffe.setTarget(worldCamera.Pos.x + mouseX,worldCamera.Pos.y + mouseY);     
        }
    }
    
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
    
    boolean getCollision(PVector Pos) {
        
        for (Wall Wand : Waende) {
            for (Wall Wall : Waende) {
                if (x + Pos.x + size / 2 >= Wall.Pos.x && x + Pos.x - size / 2 <= Wall.Pos.x + Wall.w && 
                    y + Pos.y + size / 2 >= Wall.Pos.y && y + Pos.y - size / 2 <= Wall.Pos.y + Wall.h) {
                    return true;
                } 
            }
        }
        return false;
    }
    
    
    void setProjectiles(Projectile[] Bullets) {
        EnemyProj = Bullets;
    }
    
    void setWalls(Wall[] Walls) {
        this.Waende = Walls;
        for (Weapon Waffe : Waffen) {
            Waffe.setWalls(Walls);
        }
    }
    
    void checkHit() {
        for (Projectile Bullet : EnemyProj) {
            if (Bullet.isActive) {
                
                float disX = worldCamera.Pos.x + width / 2 - Bullet.Pos.x;
                float disY = worldCamera.Pos.y + height / 2 - Bullet.Pos.y;
                if (sqrt(sq(disX) + sq(disY)) < size / 2 && Bullet.isActive) {
                    hp = hp - Bullet.damage;
                    Bullet.init();
                }
            }
        }
    }
}
