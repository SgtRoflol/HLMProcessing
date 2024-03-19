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
    
    Enemy(PVector Pos,Wall[] Walls) {
        lastSeen = new PVector(0,0);
        img = loadImage("Enemy.png");
        hitImages[0] = loadImage("EnemyDead.png");
        hitImages[1] = loadImage("EnemyDead1.png");
        hitImages[2] = loadImage("EnemyDead2.png");
        hitImages[3] = loadImage("EnemyDead3.png");
        hitIndex = int(random(0,hitImages.length));
        sway = 200;
        maxHp = 30;
        hp = maxHp;
        this.Pos = Pos;
        isAlive = true;
        size = 70;
        this.Play = Play;
        getWalls(Walls);
        //Konstruktor -> String Name, int maxAmmo, int projSpeed, 
        //int cad,float reloadTime, PVector Origin, boolean isHostile, Wall[] Walls,int damage
        Waffe = new Weapon("Waffe",15,15,10,50,new PVector(Pos.x,Pos.y),true,Waende,10);
        Waffe.cooldown = 40;
    }
    
    void getWalls(Wall[] Walls) {
        this.Waende = Walls;
    }
    
    void setPlayer(Player Play) {
        this.Play = Play;
    } 
    
    void render() {
        
        if (hp <= 0) {
            isAlive = false;
        }
        if (isAlive) {
            move();
            checkHit();
            fill(0,0,255);
            pushMatrix();
            if (!canSee() && isOnScreen()) {
                angle = atan2(Pos.x - (worldCamera.Pos.x + width / 2), Pos.y - (worldCamera.Pos.y + height / 2));
                lastSeen.x = Play.x + worldCamera.Pos.x;
                lastSeen.y = Play.y + worldCamera.Pos.y;
            }
            rectMode(CENTER);
            translate(Pos.x,Pos.y);
            rotate( -angle - HALF_PI);
            imageMode(CENTER);
            image(img,0,0,size,size);
            
            popMatrix();
            if (isOnScreen() && !canSee() && Play.isAlive) { 
                Waffe.setTarget(width / 2 + worldCamera.Pos.x + int(random( -sway,sway)),height / 2 + worldCamera.Pos.y + int(random( -sway,sway)));
                Waffe.isShooting = true;
                Waffe.shoot();
                if (sway > 0) {
                    sway -= 2;
                }
                // line(Pos.x,Pos.y,width / 2 + worldCamera.Pos.x,height / 2 + worldCamera.Pos.y);
            }
            else{
                Waffe.cooldown = int(random(10, 30));
                Waffe.isShooting = false;
                if (sway < 120) {
                    sway += 2;
                }
            }
            
        }
        else{
            pushMatrix();
            translate(Pos.x,Pos.y);
            rotate( -angle + HALF_PI);
            imageMode(CENTER);
            image(hitImages[hitIndex],0,0,hitImages[hitIndex].width * 2,hitImages[hitIndex].height * 2);
            popMatrix();
        }
        
        Waffe.render();
        
    }
    
    boolean isOnScreen() {
        if (Pos.x > worldCamera.Pos.x + width + size / 2 || Pos.x + size / 2 < worldCamera.Pos.x) {
            return false;
        }   
        if (Pos.y > worldCamera.Pos.y + height + size / 2 || Pos.y + size / 2 < worldCamera.Pos.y) {
            return false;
        }
        
        return true;
    }
    
    void setProjectiles(Projectile[] Bullets) {
        PlayerProj = Bullets;
    }
    
    void checkHit() {
        for (Projectile Bullet : PlayerProj) {
            if (!Bullet.isActive) {
                continue;
            }
            float disX = Pos.x - Bullet.Pos.x;
            float disY = Pos.y - Bullet.Pos.y;
            if (sqrt(sq(disX) + sq(disY)) < size / 2 && Bullet.isActive && isAlive) {
                hp -= Bullet.damage;
                Bullet.init();
            }
        }
        if (hp <= 0) {
            CurScene.enemyAmount--;
            int sound = int(random(0,4));
            osc.send(hitMessages[sound], meineAdresse);
            
        }
    }
    
    boolean canSee() {
        for (Wall Wand : Waende) {
            if (Wand.isOnScreen()) {
                
                if (lineRect(width / 2 + worldCamera.Pos.x,height / 2 + worldCamera.Pos.y,Pos.x,Pos.y,Wand.Pos.x,Wand.Pos.y,Wand.w,Wand.h)) {
                    return true;
                }
            } 
        }
        return false;
    }
    
    // LINE/RECTANGLE
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
