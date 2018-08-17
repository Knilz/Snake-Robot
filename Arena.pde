class Arena {
  private Capture cam;    //Kamera
  
  private int pBreite;
  private int pHoehe;

  public color[][] pic;   //2-dimensionaler Array von Farben aus Kamerabild

  float verh; //ArenaBreite/PixelBreite
  //aktuelle Position in mm von
  private PVector posFood;   //Futter
  private PVector posFront;  //vorderer Markierung der Schlange
  private PVector posBack;   //hinterer Markierung der Schlange

  //aktuelle Position im Bild von 
  private PVector pixFood;   //Futter
  private PVector pixFront;  //vorderer Markierung der Schlange
  private PVector pixBack;   //hinterer Markierung der Schlange

  public float deg; //Gradzahl (in deg) um die die Snake im Uhrzeigersinn drehen muss
  public float dist; //Distanz die der Roboter vorwärts fahren muss

  //Farbe bei tatsächlicher Beleuchtung von
  private color colFood;  //Futter
  private color colFront; //vorderer Markierung der Schlange
  private color colBack;  //hinterer Markierung der Schlange

  //einzige Konstruktor 
  public Arena(Capture cam, int pBreite, int pHoehe, float aBreite, float aHoehe) {
    this.cam = cam;
    this.cam.start();

    VerhCheck(pBreite,pHoehe,aBreite,aHoehe);
    
    this.pBreite = pBreite;
    this.pHoehe = pHoehe;

    initPix();
    updatePos();

    pic = new color[pBreite][pHoehe];

    colFront = color(81, 135, 55); //grün
    colBack = color(7, 77, 169);   //blau
    colFood = color(255, 0, 0); //rot
  }
  //wird im Hauptprogramm einmal in draw aufgerufen
  public void allesWasInDrawSoll() {
    this.camPic();
    this.drawPix();
    ellipse(mouseX, mouseY, 5, 5);
  }
  //aktualisiert alle wichtigen Daten 
  public void update() {
    updatePic();
    updatePix();
    drawPix();
    updatePos();
    updateDegDist();
  }
  //aktualisiert alle wichtigen Daten so, als ob das Futter auf der Mausposition liegen würde
  public void updateOnMouse(){
    updatePic();
    updatePix();
    this.pixFood = new PVector(mouseX,mouseY);
    updatePos();
    updateDegDist();
  }
  
  //gibt das aktuelle Bild der Kamera aus
  private void camPic() {
    //println("camPic");
    if (cam.available()) {
      //println("cam.available");
      cam.read();
    }
    image(cam, 0, 0);
  }
  //setzt alle Pixel-Positionen auf 0
  private void initPix() {
    pixFood = new PVector(0, 0);
    pixFront = new PVector(0, 0);
    pixBack = new PVector(0, 0);
  }

  //aktualisiert pixel-Positionen von Food,Front,Back anhand von Array pic
  private void updatePix() {
    initPix();

    float allDif = 1000;              //erlaubter Abstand den die Farben haben dürfen um als gesuchtes Objekt erkannt zu werden
    float bestFront = allDif;
    float bestBack = allDif;
    float bestFood = allDif;

    for (int i = 0; i<pBreite; i++) {
      for (int j = 0; j<pHoehe; j++) {
        if (colDist(pic[i][j], colFront)<bestFront) {
          pixFront.set(i, j);
          bestFront = colDist(pic[i][j], colFront);
        } else if (colDist(pic[i][j], colBack)<bestBack) {
          pixBack.set(i, j);
          bestBack = colDist(pic[i][j], colBack);
        } else if (colDist(pic[i][j], colFood)<bestFood) {
          pixFood.set(i, j);
          bestFood = colDist(pic[i][j], colFood);
        }
      }
    }
    printPix();
  }
  
  private float colDist(color a, color b) {  
    float rDif = red(a)-red(b);
    float gDif = green(a)-green(b);
    float bDif = blue(a)-blue(b);
    return new PVector(rDif, gDif, bDif).mag();
  }

  private void updatePos() {
    posFood = PVector.mult(pixFood, verh);
    posFront = PVector.mult(pixFront, verh);
    posBack = PVector.mult(pixBack, verh);

    printPos();
  }

  //berechnet aus den aktuellen Positionsvektoren den zu drehenden Winkel, und die zu fahrende Distanz
  private void updateDegDist() {
    if (!(posFood.x == 0 && posFood.y == 0)) {
      PVector rV  = PVector.sub(posFront, posBack); //Vektor von PosBack zu posFront
      PVector mp = PVector.add(posBack, PVector.mult(rV, 2/3)); //ungefährer Mittelpunkt von Schlange
      PVector mpToFood = PVector.sub(posFood, mp);
      this.dist = mpToFood.mag();
      float det = det(rV, mpToFood);
      float angle = degrees(PVector.angleBetween(rV, mpToFood));
      if (det>0) {                //könnte man über heading() wahrscheinlich genauso lösen
        this.deg = angle;
      } else {
        this.deg = 360 - angle;
      }
    } else {
      this.deg = -1;
      this.dist = -1;
    }
    printDegDist();
  }
  //gibt Determinante zweier R2 vektoren zurück
  private float det(PVector a, PVector b) {
    return (a.x*b.y) - (a.y*b.x);
  }

  //aktualisiert Array "pic"
  private void updatePic() {
    if (cam.available()) {
      cam.read();
    }
    cam.loadPixels();
    for (int i = 0; i< pBreite; i++) {
      for (int j = 0; j<pHoehe; j++) {
        pic[i][j] =  cam.pixels[pBreite*j+i];
      }
    }
  }
  //überprüft, ob das Verhältnis der übergebenen Breiten und Höhen ausreichend übereinstimmt
  private void VerhCheck(int pBreite,int pHoehe, float aBreite,float aHoehe) {
    float aVerh = aBreite/aHoehe ;
    float pVerh = pBreite/(float)pHoehe;
    float verhDif = abs(aVerh - pVerh);
    if (verhDif > 0.05) {
      println("Die Verhältnisse stimmen nicht");
      println(aVerh +", "+pVerh);
      println("Unterschied: "+verhDif);
    }
    this.verh = aBreite/pBreite;
  }
  //gibt die durchschnittliche Farbe an Stelle x,y aus
  public color avgColAt(int x, int y) {
    color[] colAr = new color[20];
    for (int i = 0; i<20; i++) {
      updatePic();
      colAr[i] = feld.pic[x][y];
    }
    return avgCol(colAr);
  }
  //gibt die Durchschnittsfarbe aus einer Listen an Farben zurück
  private color avgCol(color[] colAr) {
    float sumR = 0;
    float sumG = 0;
    float sumB = 0;
    int arL = colAr.length;
    for (int i = 0; i<arL; i++) {
      sumR += red(colAr[i]);
      sumG += green(colAr[i]);
      sumB += blue(colAr[i]);
    }
    return color(sumR/arL, sumG/arL, sumB/arL);
  }
  
  private void drawPix() {
    fill(color(255, 255, 255));
    int r = 10; //radius der Punkte
    ellipse(pixFood.x, pixFood.y, r, r);
    ellipse(pixFront.x, pixFront.y, r, r);
    ellipse(pixBack.x, pixBack.y, r, r);
  }
  private void printPix() {
    println("pixFront: "+pixFront);
    println("pixBack: "+pixBack);
    println("pixFood: "+pixFood);
  }
  private void printPos() {
    println("Front:"+ posFront);
    println("Back: " +posBack);
    println("Food: " +posFood);
  }
  private void printDegDist() {
    println("dist: " +dist);
    println("deg: " +deg);
  }

  //gibt die einzelnen Farbwerte einer Farbe in der Konsole aus
  private void printCol(color col) {
    println("Rot: "+red(col)+ ", Gruen: "+green(col) + ", Blau: "+blue(col));
  }
}