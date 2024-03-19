
class Camera {
    PVector Pos;
    int speed;
    int animTime; //Zeit in der die Kamera zittert
    float shakeStrength; //Stärke des Zitterns
    
    //Konstruktor
    Camera() {
        Pos = new PVector(0, 0);
        speed = 6;
        animTime = 0;
        shakeStrength = 3;
    }
    
    //Kamera bewegen
    void draw() {
        if (keyPressed && Play.isAlive) {
            
            //Wenn der Spieler sich mit einer Bewegung nicht in eine Wand bewegen würde, bewegt sich die Kamera
            if (keys[87]) {if (!Play.getCollision(new PVector(Pos.x,Pos.y - speed))) {Pos.y -= speed;} } 
            if (keys[83]) {if (!Play.getCollision(new PVector(Pos.x,Pos.y + speed))) {Pos.y += speed;} } 
            if (keys[65]) {if (!Play.getCollision(new PVector(Pos.x - speed,Pos.y))) {Pos.x -= speed;} } 
            if (keys[68]) {if (!Play.getCollision(new PVector(Pos.x + speed,Pos.y))) {Pos.x += speed;} } 
            
        }
    }
    
    //Screenshake dauer setzen
    void screenshake(int time) {
        if (time != 0) {
            animTime = time;
            screenshake();
        }
        
    }
    
    void screenshake() {
        //Berechnet eine zufällige Bewegung für die Kamera
        float moveX = random( -shakeStrength,shakeStrength);
        float moveY = random( -shakeStrength,shakeStrength);
        //Bewegt die Kamera wenn die Zeit nicht abgelaufen ist
        if (animTime != 0) {
            translate(moveX, moveY);
        }
        //Wenn die Zeit abgelaufen ist, wird die Kamera wieder auf die Mitte gesetzt
        if (animTime <= 0) {
            animTime = 0;
            Play.x = width / 2;
            Play.y = height / 2;
        }
        else{
            //Zeit wird verringert
            animTime--;
        }
        
    }
}
