class Enemy{
    boolean isAlive;
    PVector Pos;
    Projectile[] PlayerProj;
    int size;
    Wall[] Waende;
    Player Play;
    Weapon Waffe;
    
    Enemy(PVector Pos,Wall[] Walls) {
        this.Pos = Pos;
        isAlive = true;
        size = 50;
        this.Play = Play;
        getWalls(Walls);
        //Konstruktor -> String Name, int maxAmmo, int projSpeed, 
        //int cad,float reloadTime, PVector Origin, boolean isHostile, Wall[] Walls
        Waffe = new Weapon("Waffe",100,10,20,0,new PVector(Pos.x,Pos.y),true,Waende);
        Waffe.cooldown = 40;
    }
    
    void getWalls(Wall[] Walls) {
        this.Waende = Walls;
    }
    
    void setPlayer(Player Play) {
        this.Play = Play;
    } 
    
    void render() {
        checkHit();
        if (isAlive) {
            fill(0,0,255);
            ellipse(Pos.x,Pos.y,size,size);
            if (isOnScreen() && !canSee()) { 
                Waffe.setTarget(width / 2 + worldCamera.Pos.x,height / 2 + worldCamera.Pos.y);
                Waffe.isShooting = true;
                Waffe.shoot();
                line(Pos.x,Pos.y,width / 2 + worldCamera.Pos.x,height / 2 + worldCamera.Pos.y);
            }
            else{
                Waffe.cooldown = 30;
                Waffe.isShooting = false;
            }
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
                isAlive = false;
                Bullet.init();
            }
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
            println("HUHU");
            return true;
            
        }
        println("Huch");
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
}
