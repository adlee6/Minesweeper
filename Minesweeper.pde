import de.bezier.guido.*;
int NUM_ROWS = 20;
int NUM_COLS = 20;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined


void setup ()
{
    size(400, 450);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    
    buttons = new MSButton [NUM_ROWS][NUM_COLS];
    for(int j = 0; j < buttons.length; j++)
      for(int i = 0; i < buttons[j].length; i++)
          buttons[j][i] = new MSButton(j,i);
    
    setMines();
}
public void setMines()
{
  for(int i = 0; i < 40; i++) {
  int rr = (int)(Math.random()*NUM_ROWS);
   int cc = (int)(Math.random()*NUM_COLS);
     if(!mines.contains(buttons[rr][cc]))
         mines.add(buttons[rr][cc]);
  }
}

public void draw ()
{
    background( 255 );
    text("Number of Bombs:" + mines.size(),65,425);
    if(isWon() == true)
        displayWinningMessage();
}
public boolean isWon()
{
    int count = 0;
    for(int r = 0; r < NUM_ROWS; r++)
      for(int c = 0; c < NUM_COLS; c++)
        if(buttons[r][c].clicked == false || buttons[r][c].isFlagged()==true)
          count++;
    if(count == mines.size())
      return true;
    else
    return false;
}
public void displayLosingMessage()
{    
    for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++) {
        buttons[i][j].setClicked(true);
        buttons[i][j].setFlagged(false);
        buttons[i][j].setLabel("");
      }
    }
    buttons[9][9].setLabel("B");
    buttons[9][10].setLabel("O");
    buttons[9][11].setLabel("O");
}
public void displayWinningMessage()
{
   for(int i = 0; i < NUM_ROWS; i++){
      for(int j = 0; j < NUM_COLS; j++) {
        buttons[i][j].setClicked(true);
        buttons[i][j].setFlagged(false);
        buttons[i][j].setLabel("");
      }
   }
    buttons[9][9].setLabel("Y");
    buttons[9][10].setLabel("A");
    buttons[9][11].setLabel("Y");
}
public boolean isValid(int r, int c)
{
    return (r>=0) && (r <NUM_ROWS) && (c>=0) && (c < NUM_COLS);
}
public int countMines(int row, int col)
{
    int numMines = 0;
    for(int r = row-1; r <= row+1; r++)
      for(int c = col-1; c <= col+1; c++)
        if(isValid(r,c) && mines.contains(buttons[r][c]))
          numMines++;
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
    }

    // called by manager
    public void mousePressed () 
    {
        clicked = true;
        if(mouseButton == RIGHT) {
          if(flagged == false) {
            flagged = true;
          } else {
            flagged = false; 
            clicked = false;
          }
        } else if(mines.contains(this)&&flagged == false){
          displayLosingMessage();
        }
          else if(countMines(myRow, myCol) > 0) {
           myLabel = String.valueOf(countMines(myRow,myCol));
          }
          else if(isWon() == true){
        displayWinningMessage();
          }
          else {
          for(int j = myRow - 1; j <= myRow+1; j++)
            for(int i = myCol - 1; i <= myCol + 1; i++)
            if(isValid(j,i) && buttons[j][i].clicked == false)
              buttons[j][i].mousePressed();
          }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
        else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(myLabel,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean setFlagged(boolean res)
    {
       return flagged = res;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    public boolean setClicked(boolean var)
    {
       return clicked = var; 
    }
}
