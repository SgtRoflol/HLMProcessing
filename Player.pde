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
    
    Player(Wall[] Waende) {
        //Position auf Bildschirmmitte legen und Farbe festlegen
        hp = 100;
        x = width / 2;
        y = height / 2;
        Origin = new PVector(worldCamera.Pos.x + height / 2,worldCamera.Pos.y + height / 2);    
        farbe = color(255,0,0);
        size = 50;
        this.Waende = Waende;
        
        Waffen = new Weapon[3]; //Arraylänge definieren
        Waffen[0] = new Weapon("Waffe",30,10,5,50,Origin,false,CurScene.getWalls());// Konstruktor -> String Name, int maxAmmo, int projSpeed, int cad
        Waffen[1] = new Weapon("Waffe2",10,20,30,60,Origin,false,CurScene.getWalls());
        Waffen[2] = new Weapon("Waffe3",5,40,70,100,Origin,false,CurScene.getWalls()); 
    }
    
    
    void render() {
        //Spieler zeichnen, aktuelle fill Farbe speichern und später zurücksetzen
        if (hp <= 0) {
            farbe = (color(0));
        }
        checkHit();
        color curcol = g.fillColor;
        fill(farbe);
        rectMode(CENTER);
        rect(0,0,size,size);
        fill(curcol);
        println(getCollision(worldCamera.Pos));
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
        //Spielerrechteck zur Maus hindrehen
        pushMatrix();
        angle = atan2(x - mouseX, y - mouseY);
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
    
    void checkHit() {
        for (Projectile Bullet : EnemyProj) {
            if (!Bullet.isActive) {
                continue;
            }
            float disX = worldCamera.Pos.x + width / 2 - Bullet.Pos.x;
            float disY = worldCamera.Pos.y + height / 2 - Bullet.Pos.y;
            if (sqrt(sq(disX) + sq(disY)) < size / 2 && Bullet.isActive) {
                hp = hp - 10;
                println("AUA");
                Bullet.init();
            }
        }
    }
}
