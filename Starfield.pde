import java.util.ArrayList;

ArrayList<Particle> particles = new ArrayList<Particle>();




void setup()
{
    size(800, 800);
}

void draw()
{
    background(0);
    fill(255);

    if(frameCount%50==0)
    {
        double x = (Math.random()*width);
        double y = (double)height;
        double Vx = Math.random()*5-2.5;
        double Vy = -(Math.random()*4+10);
        double t = 2;
        double size = 10;
        double g = 9.8;
        color Pcolor = color(255, 250, 220);    
        particles.add(new FireWork(x, y, Vx, Vy, t, size, g, Pcolor));
    } 
    
    for(int i = particles.size() - 1; i >= 0; i--)
    {
        Particle p = particles.get(i);
        p.update();
        p.show();
        if(p.isDead())
        {
            if(p instanceof FireWork)
            {
                int rings = 6;                           // number of concentric rings
                int perRing = 50;                        // fragments per ring (even angular spacing)
                double baseSpeed = 2.0;
                for(int r = 0; r < rings; r++)
                {

                    double radius = baseSpeed * ( (r + 0.5) / rings ); 

                    double angleOffset = Math.random() * (Math.PI * 2.0 / perRing);

                    for(int k = 0; k < perRing; k++)
                    {
                        double angle = k * (Math.PI * 2.0) / perRing + angleOffset;

                        double vx = Math.cos(angle) * radius  + (Math.random()*.3-.15);
                        double vy = -(Math.sin(angle) * radius  + (Math.random()*.3-.15));


                        double fragSize = 1.5 + (rings - r) * 0.6 + Math.random() * 0.6;
                        double fragLife = 1.0 + Math.random() * 0.6;
                        
                        color Pcolor = particles.get(i).Pcolor; 

                        particles.add(new Split(p.x, p.y, vx, vy, fragLife, fragSize, .4, Pcolor));
                    }
                }
            }
            particles.remove(i);
        }
    }
}
class Particle
{
    private double x, y, Vx, Vy, t, size, g;
    private color Pcolor;
    Particle(double x, double y, double Vx, double Vy, double t, double size, double g, color Pcolor)
    {
        this.x = x;
        this.y = y;
        this.Vx = Vx;
        this.Vy = Vy;
        this.t = t;
        this.size = size;
        this.g = g;
        this.Pcolor = Pcolor;
    }

    void update()
    {
        t -= 1.0/frameRate;
        Vy += g/frameRate;
        
        x += Vx;
        y += Vy;

        Vx *= .99;
        Vy *= .99;
    }

    void show()
    {
        fill(Pcolor);
        ellipse((float)x, (float)y, (float)size, (float)size);

    }

    boolean isDead()
    {
        return t <= 0;
    }

    public double getX(){ return x; }    public double getY(){ return y; }
    public double getVx(){ return Vx; }  public double getVy(){ return Vy; }
    public double getT(){ return t; }    public double getSize(){ return size; }
    public double getG(){ return g; }    public color getColor(){ return Pcolor; }

    protected void setX(double v){ x = v; }    protected void setY(double v){ y = v; }
    protected void setVx(double v){ Vx = v; }  protected void setVy(double v){ Vy = v; }
    protected void setT(double v){ t = v; }    protected void setSize(double v){ size = v; }
}
class FireWork extends Particle
{
    FireWork(double x, double y, double Vx, double Vy, double t, double size, double g, color Pcolor)
    {
        super(x, y, Vx, Vy, t, size, g, Pcolor);
    }
    void update()
    {
        if(frameCount % 5 == 0)
        {
            particles.add(new Trail(getX(), getY(), 0, 0, .7, 5, .1, getColor()));
        }
        if(getVy()>.5) setT(0);

        setT(getT()-1.0/frameRate);
        setVy(getVy() + getG()/frameRate);
        
        setX(getX() + getVx());
        setY(getY() + getVy());
    }

}
class Trail extends Particle
{   

    Trail(double x, double y, double Vx, double Vy, double t, double size, double g, color Pcolor)
    {
        super(x, y, Vx, Vy, t, size, g, Pcolor);
    }


}
class Split extends Particle
{
    Split(double x, double y, double Vx, double Vy, double t, double size, double g, color Pcolor)
    {
        super(x, y, Vx, Vy, t, size, g, Pcolor);
    }

}
