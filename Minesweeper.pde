import de.bezier.guido.*;
public static final int NUM_ROWS = 20;
public static final int NUM_COLS = 20;
public final static int NUM_BOMBS = 50;
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs = new ArrayList <MSButton>(); //ArrayList of just the minesweeper buttons that are mined
private boolean gameOver = false;
private int boom = NUM_BOMBS;
private int safe = (NUM_ROWS*NUM_COLS)-(NUM_BOMBS);

void setup ()
{
  size(400, 450);
  textAlign(CENTER, CENTER);
  // make the manager
  Interactive.make( this );
  buttons = new MSButton[NUM_ROWS][NUM_COLS];
  for (int nRows = 0; nRows < NUM_ROWS; nRows++)
    for (int nCols = 0; nCols < NUM_COLS; nCols++)
      buttons[nRows][nCols] = new MSButton(nRows, nCols);
  for (int bomb = 0; bomb < NUM_BOMBS; bomb++)
    setBombs();
}
public void setBombs()
{
  int bRow = (int)(Math.random()*NUM_ROWS);
  int bCol = (int)(Math.random()*NUM_COLS);
  if (!bombs.contains(buttons[bRow][bCol]))
    bombs.add(buttons[bRow][bCol]);
  else
    setBombs();
}

public void draw ()
{
  if (gameOver == false)
  {
    background(255);
    textSize(20);
    text("bombsleft: " + boom, 150, 30);
  }
  if (youWin())
    Winner();
}
public boolean youWin()
{
  if (safe == 0) return true;
  else if (boom != 0) return false;
  else if (boom == 0)
  {
    for (int i = 0; i < bombs.size(); i++)
      if (!bombs.get(i).isMarked())
        return false;
  }
  return true;
}
public void Loser()
{
  for (int i = 0; i < bombs.size(); i++)
    if (bombs.get(i).isMarked() == false)
      bombs.get(i).clicked = true;
  fill(255);
  rect(0, 0, 400, 50);
  fill(0);
  textSize(30);
  text("LOSER!", 200, 30);
  gameOver = true;
}
public void Winner()
{
  fill(255);
  rect(0, 0, 400, 50);
  fill(0);
  textSize(20);
  text("WINNER!", 200, 30);
  gameOver = true;
}

public class MSButton
{
  private int r, c;
  private float x, y, width, height;
  private boolean clicked, marked;
  private String label;

  public MSButton ( int rr, int cc )
  {
    width = 400/NUM_COLS;
    height = 400/NUM_ROWS;
    r = rr;
    c = cc; 
    x = c*width;
    y = r*height+50;
    label = "";
    marked = clicked = false;
    Interactive.add( this ); // register it with the manager
  }
  public boolean isMarked()
  {
    return marked;
  }
  public boolean isClicked()
  {
    return clicked;
  }

  public void mousePressed () 
  {
    if (gameOver == false)
    {
      if (mouseButton == LEFT && marked == false)
      {
        clicked = true;
        safe--;
      }
      if (mouseButton == RIGHT && clicked == false)
      {
        marked = !marked;
        if (!isMarked())
          boom++;
        else if (isMarked())
          boom--;
      } 
      else if (bombs.contains( this ) && marked == false)
        Loser();
      else if (countBombs(r, c)>0)
        setLabel(str(countBombs(r, c)));
      else
        for (int i = -1; i <= 1; i++)
          for (int j = -1; j <= 1; j++)
            if (isValid(r+i, c+j) && !buttons[r+i][c+j].isClicked())
              buttons[r+i][c+j].mousePressed();
    }
  }

  public void draw () 
  {    
    if (marked)
      fill(0);
    else if ( clicked && bombs.contains(this) ) 
      fill(5, 255, 20);
    else if (clicked)
      fill(100);
    else 
    fill( 100,20,50);

    rect(x, y, width, height);
    fill(0);
    textSize(12);
    text(label, x+width/2, y+height/2);
  }
  public void setLabel(String newLabel)
  {
    label = newLabel;
  }
  public boolean isValid(int r, int c)
  {
    if (r >= 0 && r < NUM_ROWS && c >= 0 && c < NUM_COLS)
      return true;
    return false;
  }
  public int countBombs(int row, int col)
  {
    int numBombs = 0;
    for (int i = -1; i <= 1; i++)
      for (int j = -1; j <= 1; j++)
        if (isValid(row+i, col+j) && bombs.contains(buttons[row+i][col+j]))
          numBombs++;
    return numBombs;
  }
}
