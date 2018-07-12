/*   //gibt zurück ob sich die Farben ausreichend ähneln
   private boolean colSimil(color a,color b){  
     float rDif = red(a)-red(b);
     float gDif = green(a)-green(b);
     float bDif = blue(a)-blue(b);
     
     float absR = abs(rDif);
     float absG = abs(gDif);
     float absB = abs(bDif);
     return colSimil(absR,absG,absB);
   }
   //kriegt r,g und b Abstand von zwei Farben übergeben und überprüft, ob 
   private boolean colSimil(float r, float g,float b){
     float tmDif = 45;           //total maximum Difference
     float smDif = 15;           //single maximum Difference
     return (r+g+b <= tmDif && r<smDif && g<smDif && b<smDif);
   }
   private boolean colSame(float r,float g,float b){
     float lmDif = 30;           //light maximum difference
     return floatSimil(new float[]{r,g,b},10);
   }
   //gibt zurück ob sich in einem float-Array alle einzelnen Einträge paarweise nicht zu stark unterscheiden, 
   private boolean floatSimil(float[] flAr, float allDif){
    for(int i = 0; i<flAr.length;i++){
     for(int j = i; j< flAr.length;j++){
        if(abs(flAr[i]-flAr[j])>allDif){
           return false; 
        }
     }
    }
    return true;
   }
   
   private void initCols(){
    //Farben bei optimaler Beleuchtung:
      color oHint = color(255,255,255);  //weiß
      color oFront = color(255,0,0);     //rot
      color oBack = color(0,255,0);      //grün  
      color oFood = color(0,0,255);      //blau
      
      colHint = pic[(int)(pBreite/2)][(int)(pHoehe/2)];
      
      color dif = color(red(oHint)-red(colHint),green(oHint)-green(colHint),blue(oHint)-blue(colHint));
      
      colFront = color(red(oFront)-red(dif),green(oFront)-green(dif),blue(oFront)-blue(dif));
      colBack = color(red(oBack)-red(dif),green(oBack)-green(dif),blue(oBack)-blue(dif));
      colFront = color(red(oFood)-red(dif),green(oFood)-green(dif),blue(oFood)-blue(dif));
  }
  
   //gibt den PixelArray aus (für Tests),schneller ist camPic benutzen
   private void displayPic(){
     for(int i = 0;i< pBreite;i++){
      for(int j = 0;j<pHoehe;j++){
       stroke(pic[i][j]);
       point(i,j);
      }
     }
   }   
*/
