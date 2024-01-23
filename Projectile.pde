class Projectile{
    boolean isActive;
    PVector Pos;
    float speed;
    PVector dir;
    Wall[] Walls;
    
    Projectile(float speed) {
        this.speed = speed;
        init();
    }
    
    void init() {
        //Setzt Projektil zurück, setzt auf Spielerposition und setzt Zielposition auf 0
        isActive = false;
        Pos = new PVector(width / 2,height / 2);
        Pos.x = worldCamera.pos.x + width / 2;
        Pos.y = worldCamera.pos.y + height / 2;
        dir = new PVector(0,0);
    }
    
    void spawn() {
        
        //Wird erst zurückgesetzt
        //Mausvektor
        //Zeilvektor wird berechnet -> Verbindungsvektor von Spielerpsition zu Mausposition
        init();
        PVector mouse = new PVector(worldCamera.pos.x + mouseX,worldCamera.pos.y + mouseY);
        dir = PVector.sub(mouse,Pos);
        
        //Vektor wird normalisiert -> Alle Komponenten werden durch den selben Wert dividiert
        //Vektorrichtung bleibt gleich aber länge wird 1
        //Richtungsvektor wird mit Geschwindigkeit multipliziert -> Vekor wird um Geschwindigkeitswert verlängert
        //Projektil wird auf aktiv gesetzt -> Nicht mehr an Spieler fixiert, sondern kann sich nun richtung Ziel Bewegen
        dir.normalize();
        dir.mult(speed);
        isActive = true;
    }
    
    void render() {
        //Kreis wird mittig von Koordinaten aus gezeichnet
        //Aktuell in draw genutzte Farbe wird gespeichert und später auf diesen Wert zurückgesetzt
        //um Farbfehler zu vermeiden
        ellipseMode(CENTER);
        color curcol = g.fillColor;
        fill(255, 255, 0);
        
        if (isActive) {
            //Überprüfung, ob sich das Projektil ausserhalb des Bildschirms befindet
            //Projektil wird um Richtungsvektor verschoben
            //Projektil wird gezeichnet
            checkBounds();
            Pos = Pos.add(dir);
            ellipse(Pos.x,Pos.y,10,10);   
        }
        //Wenn nicht aktiv, fixiert auf Spielerposition
        else{
            Pos.x = worldCamera.pos.x + width / 2;
            Pos.y = worldCamera.pos.y + height / 2;
        }   
        //Farbe wird auf vorherigen Wert zurückgesett
        fill(curcol);
    }
    
    void checkBounds() {
        
        //Wenn sich das Projektil ausserhalb des Bildschirms befindet, wird es zurückgesetzt
        if (Pos.x > worldCamera.pos.x + width || Pos.x < worldCamera.pos.x) {
            init();
        }    
        if (Pos.y > worldCamera.pos.y + height || Pos.y < worldCamera.pos.y) {
            init();
        }
    }
    
}
