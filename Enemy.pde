class Enemy{
    boolean isAlive;
    PVector Pos;
    Projectile[] PlayerProj;
    int size;
    
    
    Enemy(PVector Pos) {
        this.Pos = Pos;
        isAlive = true;
        size = 50;
    }
    
    
    
    void render() {
        checkCollision();
        if (isAlive) {
            fill(0,0,255);
            ellipse(Pos.x,Pos.y,size,size);
            if (isOnScreen()) {
                line(Pos.x,Pos.y,width / 2 + worldCamera.pos.x,height / 2 + worldCamera.pos.y);
            }
        }
    }
    
    boolean isOnScreen() {
        if (Pos.x > worldCamera.pos.x + width + size || Pos.x + size < worldCamera.pos.x) {
            return false;
        }   
        if (Pos.y > worldCamera.pos.y + height + size || Pos.y + size < worldCamera.pos.y) {
            return false;
        }
        
        return true;
    }
    
    void setProjectiles(Projectile[] Bullets) {
        PlayerProj = Bullets;
    }
    
    void checkCollision() {
        for (Projectile Bullet : PlayerProj) {
            float disX = Pos.x - Bullet.Pos.x;
            float disY = Pos.y - Bullet.Pos.y;
            if (sqrt(sq(disX) + sq(disY)) < size / 2 && Bullet.isActive && isAlive) {
                isAlive = false;
                Bullet.init();
            }
        }
    }
    
}
