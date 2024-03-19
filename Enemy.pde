class Enemy{
    float angle;
    int hp;
    int maxHp;
    boolean isAlive;
    PVector Pos;
    Projectile[] PlayerProj;
    int size;
    Wall[] Waende;
    Player Play;
    Weapon Waffe;
    int sway;
    PImage img;
    PImage[] hitImages = new PImage[4];
    PVector lastSeen;
    int hitIndex;
    
    //Kostruktor
    Enemy(PVector Pos,Wall[] Walls) {
        lastSeen = new PVector(0,0);
        //Bild für den Gegner
        img = loadImage("Enemy.png");
        //Bilder für den Tod des Gegners
        hitImages[0] = loadImage("EnemyDead.png");
        hitImages[1] = loadImage("EnemyDead1.png");
        hitImages[2] = loadImage("EnemyDead2.png");
        hitImages[3] = loadImage("EnemyDead3.png");
        //Bild auswählen für den Tod
        hitIndex = int(random(0,hitImages.length));
        //Ungeauigkeit des Gegners
        sway = 200;
        //Leben des Gegners
        maxHp = 30;
        hp = maxHp;
        //Position des Gegners
        this.Pos = Pos;
        isAlive = true; //Der Gegner lebt
        size = 70; //Größe des Gegners
        this.Play = Play; //Spieler
        getWalls(Walls); //Wände des Levels werden übergeben
        //Waffe des Gegners;
        Waffe = new Weapon("Waffe",7,15,10,50,new PVector(Pos.x,Pos.y),true,Waende,10);
        //Cooldown der Waffe
        Waffe.cooldown = 40;
    }
    
    //Wände des Levels werden übergeben
    void getWalls(Wall[] Walls) {
        this.Waende = Walls;
    }
    //Spieler wird übergeben
    void setPlayer(Player Play) {
        this.Play = Play;
    } 
    
    //Gegner wird gerendert
    void render() {
        
        if (hp <= 0) {
            //Gegner stirbt
            isAlive = false;
        }
        //Wenn der Gegner lebt
        if (isAlive) {
            //Gegner bewegt sich
            move();
            checkHit(); //Überprüft ob der Gegner getroffen wurde
            pushMatrix(); 
            //Wenn der Gegner den Spieler sehen kann und auf dem Bildschirm ist
            if (!canSee() && isOnScreen()) {
                //Berechnet den Winkel zwischen Spieler und Gegner
                angle = atan2(Pos.x - (worldCamera.Pos.x + width / 2), Pos.y - (worldCamera.Pos.y + height / 2));
                //Speichert die letze bekannte Position des Spielers
                lastSeen.x = Play.x + worldCamera.Pos.x;
                lastSeen.y = Play.y + worldCamera.Pos.y;
            }
            //Zeichnet den Gegner
            rectMode(CENTER);
            translate(Pos.x,Pos.y);
            //Dreht den Gegner in die Richtung des Spielers
            rotate( -angle - HALF_PI);
            imageMode(CENTER);
            //Zeichnet das Bild des Gegners
            image(img,0,0,size,size);
            
            popMatrix();
            //Wenn der Gegner den Spieler sehen kann und auf dem Bildschirm ist und der Spieler lebt
            if (isOnScreen() && !canSee() && Play.isAlive) { 
                //Zielt auf den Spieler
                Waffe.setTarget(width / 2 + worldCamera.Pos.x + int(random( -sway,sway)),height / 2 + worldCamera.Pos.y + int(random( -sway,sway)));
                //Gegner schießt
                Waffe.isShooting = true;
                Waffe.shoot();
                //Abweichung der Kugeln wird verringert je länger der Gegner schießt
                if (sway > 0) {
                    sway -= 2;
                }
            }
            else{
                //Gegner schießt nicht
                Waffe.cooldown = int(random(10, 30)); //Cooldown der Waffe wird zufällig gewählt
                Waffe.isShooting = false;
                //Abweichung der Kugeln wird erhöht wenn der Gegner den Spieler nicht sieht
                if (sway < 120) { //Maximale Abweichung niedriger als Anfangsabweichung -> Gegner wird genauer
                    sway += 2;
                }
            }
            
        }
        else{
            //Gegner ist tot
            pushMatrix();
            translate(Pos.x,Pos.y);
            //Dreht den Gegner weg von der Richtung des Spielers
            rotate( -angle + HALF_PI);
            imageMode(CENTER);
            //Zeichnet das Bild des toten Gegners
            image(hitImages[hitIndex],0,0,hitImages[hitIndex].width * 2,hitImages[hitIndex].height * 2);
            popMatrix();
        }
        //Zeichnet die Kugeln des Gegners
        Waffe.render();
        
    }
    
    //Überprüft ob der Gegner auf dem Bildschirm ist
    boolean isOnScreen() {
        if (Pos.x > worldCamera.Pos.x + width + size / 2 || Pos.x + size / 2 < worldCamera.Pos.x) {
            return false;
        }   
        if (Pos.y > worldCamera.Pos.y + height + size / 2 || Pos.y + size / 2 < worldCamera.Pos.y) {
            return false;
        }
        
        return true;
    }
    
    //Kugeln des Spielers werden übergeben
    void setProjectiles(Projectile[] Bullets) {
        PlayerProj = Bullets;
    }
    
    //Überprüft ob der Gegner getroffen wurde
    void checkHit() {
        //Für jede Kugel des Spielers
        for (Projectile Bullet : PlayerProj) {
            //Wenn die Kugel nicht aktiv ist wird sie übersprungen
            if (!Bullet.isActive) {
                continue;
            }
            //Berechnet die Distanz zwischen Kugel und Gegner
            float disX = Pos.x - Bullet.Pos.x;
            float disY = Pos.y - Bullet.Pos.y;
            //Wenn die Distanz kleiner als der Radius des Gegners ist und die Kugel aktiv ist und der Gegner lebt
            if (sqrt(sq(disX) + sq(disY)) < size / 2 && Bullet.isActive && isAlive) {
                //Gegner verliert Leben
                hp -= Bullet.damage;
                //Kugel wird zurückgesetzt
                Bullet.init();
            }
        }
        //Wenn der Gegner keine Leben mehr hat wird die Gesamtanzahl der Gegner verringert und ein Sound wird abgespielt
        if (hp <= 0) {
            CurScene.enemyAmount--;
            //zufälligen Treffer Sound abspielen
            int sound = int(random(0,4));
            osc.send(hitMessages[sound], meineAdresse);
            
        }
    }
    
    boolean canSee() {
        //Für jede Wand
        for (Wall Wand : Waende) {
            //Wenn die Wand auf dem Bildschirm ist
            if (Wand.isOnScreen()) {
                //Wenn die Linie zwischen Spieler und Gegner die Wand schneidet sieht der Gegner den Spieler nicht
                if (lineRect(width / 2 + worldCamera.Pos.x,height / 2 + worldCamera.Pos.y,Pos.x,Pos.y,Wand.Pos.x,Wand.Pos.y,Wand.w,Wand.h)) {
                    return true;
                }
            } 
        }
        //der Gegner sieht den Spieler
        return false;
    }
    
    // LINE / RECTANGLE
    boolean lineRect(float x1, float y1, float x2, float y2, float rx, float ry, float rw, float rh) {
        
        // check if the line has hit any of the rectangle's sides
        // uses the Line/Line function below
        boolean left =   lineLine(x1,y1,x2,y2, rx,ry,rx, ry + rh);
        boolean right =  lineLine(x1,y1,x2,y2, rx + rw,ry, rx + rw,ry + rh);
        boolean top =    lineLine(x1,y1,x2,y2, rx,ry, rx + rw,ry);
        boolean bottom = lineLine(x1,y1,x2,y2, rx,ry + rh, rx + rw,ry + rh);
        
        // if ANY of the above are true, the line
        //has hit the rectangle
        if (left || right || top || bottom) {
            return true;
            
        }
        return false;
        
    }
    
    
    // LINE / LINE
    boolean lineLine(float x1, float y1, float x2, float y2, float x3, float y3, float x4, float y4) {
        
        // calculate the direction of the lines
        float uA = ((x4 - x3) * (y1 - y3) - (y4 - y3) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));
        float uB = ((x2 - x1) * (y1 - y3) - (y2 - y1) * (x1 - x3)) / ((y4 - y3) * (x2 - x1) - (x4 - x3) * (y2 - y1));
        
        // if uA and uB are between 0 - 1, lines are colliding
        if (uA >= 0 && uA <= 1 && uB >= 0 && uB <= 1) {
            
            return true;
        }
        return false;
    }
    
    void move() {
        if (lastSeen.x != 0 && lastSeen.y != 0 && Play.isAlive) {
            //get distance vector between enemy position and player position
            PVector distance = new PVector(lastSeen.x - Pos.x,lastSeen.y - Pos.y);
            //check if corners of enemy sprite would collide with wall
            for (Wall Wand : Waende) {
                if (Wand.isOnScreen()) {
                    if (lineRect(Pos.x - size / 2,Pos.y - size / 2,Pos.x + size / 2,Pos.y + size / 2,Wand.Pos.x,Wand.Pos.y,Wand.w,Wand.h)) {
                        lastSeen.x = 0;
                        lastSeen.y = 0;
                    }
                }
            }
            if (distance.x <= 4  && distance.y <= 4) {
                lastSeen.x = 0;
                lastSeen.y = 0;
            }
            //normalize the vector
            distance.normalize();
            //multiply the vector by the speed
            distance.mult(3);
            //add the vector to the position
            Pos.add(distance);
            //move enemy bullets to enemy position
            Waffe.Origin = Pos;
        }
    }
    
}
