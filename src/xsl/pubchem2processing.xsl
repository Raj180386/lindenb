<?xml version="1.0" encoding="UTF-8"?>
<xsl:stylesheet
 version="1.0"
 xmlns:c="http://www.ncbi.nlm.nih.gov"
 xmlns:xsl="http://www.w3.org/1999/XSL/Transform"
 xmlns:svg="http://www.w3.org/2000/svg"
 xmlns:xlink="http://www.w3.org/1999/xlink"
 xmlns:h="http://www.w3.org/1999/xhtml"
 >
 
 <!--

Motivation:
	transforms a pubchem 3D xml result to Processing
Author
	Pierre Lindenbaum PhD plindenbaum@yahoo.fr
	http://plindenbaum.blogspot.com
	http://code.google.com/p/lindenb/source/browse/trunk/src/xsl/pubchem2processing.xsl 


-->

<!-- ========================================================================= -->
<xsl:output method='text' omit-xml-declaration="yes"/>



<!-- array of atoms -->
<xsl:variable name="a_array" select="/c:PC-Compound/c:PC-Compound_atoms/c:PC-Atoms/c:PC-Atoms_element"/>
<xsl:variable name="conformers" select="/c:PC-Compound/c:PC-Compound_coords/c:PC-Coordinates/c:PC-Coordinates_conformers/c:PC-Conformer"/>

<xsl:variable name="x_array" select="$conformers/c:PC-Conformer_x"/>
<xsl:variable name="y_array" select="$conformers/c:PC-Conformer_y"/>
<xsl:variable name="z_array" select="$conformers/c:PC-Conformer_z"/>

<!-- array of bound -->
<xsl:variable name="b_array" select="/c:PC-Compound/c:PC-Compound_bonds/c:PC-Bonds"/>
<xsl:variable name="bound1_array" select="$b_array/c:PC-Bonds_aid1"/>
<xsl:variable name="bound2_array" select="$b_array/c:PC-Bonds_aid2"/>




<xsl:template match="/">
<xsl:apply-templates select="c:PC-Compound"/>
</xsl:template>


<xsl:template match="c:PC-Compound">
/**
 *	Made with http://code.google.com/p/lindenb/source/browse/trunk/src/xsl/pubchem2processing.xsl 	
 *	Author: Pierre Lindenbaum PhD plindenbaum@yahoo.fr
 *	http://plindenbaum.blogspot.com
 */
 
//number of atoms
static final int ATOM_COUNT=<xsl:value-of select="count($a_array/c:PC-Element)"/>;

//array of X positions
static final float array_x[]=new float[]{<xsl:for-each select="$x_array/c:PC-Conformer_x_E">
		<xsl:if test="position() != 1"><xsl:text>f,</xsl:text></xsl:if>
		<xsl:value-of select="." />
	</xsl:for-each>};

//array of Y positions
static final float array_y[]=new float[]{<xsl:for-each select="$y_array/c:PC-Conformer_y_E">
		<xsl:if test="position() != 1"><xsl:text>f,</xsl:text></xsl:if>
		<xsl:value-of select="." />
	</xsl:for-each>};
	
//array of Z positions
static final float array_z[]=new float[]{<xsl:for-each select="$z_array/c:PC-Conformer_z_E">
		<xsl:if test="position() != 1"><xsl:text>f,</xsl:text></xsl:if>
		<xsl:value-of select="." />
	</xsl:for-each>};

//array of atom names
static final char array_c[]=new char[]{<xsl:for-each select="$a_array/c:PC-Element">
	<xsl:if test="position() != 1"><xsl:text>,</xsl:text></xsl:if>
		<xsl:text>&apos;</xsl:text><xsl:value-of select="@value" /><xsl:text>&apos;</xsl:text>
	</xsl:for-each>};

//number of bounds
static final int BOUND_COUNT=<xsl:value-of select="count($bound1_array/c:PC-Bonds_aid1_E)"/>;

//bound start index
static final int bound_start[]=new int[]{<xsl:for-each select="$bound1_array/c:PC-Bonds_aid1_E">
		<xsl:if test="position() != 1"><xsl:text>,</xsl:text></xsl:if>
		<xsl:value-of select="number(.)-1" />
	</xsl:for-each>};
	
//bound end index
static final int bound_end[]=new int[]{<xsl:for-each select="$bound2_array/c:PC-Bonds_aid2_E">
		<xsl:if test="position() != 1"><xsl:text>,</xsl:text></xsl:if>
		<xsl:value-of select="number(.)-1" />
	</xsl:for-each>};
	
//Name of this product
static final String title= "<xsl:value-of select="c:PC-Compound_id/c:PC-CompoundType/c:PC-CompoundType_id/c:PC-CompoundType_id_cid"/>";


float mid_x=0f;
float mid_y=0f;
float mid_z=0f;
float alpha=150;
float zoom=10f;
float zoomAtom=1.0f;
boolean drawBounds=true;

void setup()
  {
 
  size(
  	500,
  	500,
  	P3D);
  mid_x= center(array_x);
  mid_y= center(array_y);
  mid_z= center(array_z);
 }

void draw()
  {
 lights();
  background(0);

  translate(width / 2, height / 2,0);
  rotateY(map(mouseX, 0, width, 0, TWO_PI));
  rotateZ(map(mouseY, 0, height, 0, -TWO_PI));
 stroke(170, 0, 0);
  for(int i=0;drawBounds &amp;&amp; i&lt; BOUND_COUNT;++i)
        {
        line(
                xAngstrom(array_x[bound_start[i]] -mid_x ),
                xAngstrom(array_y[bound_start[i]] -mid_y),
                xAngstrom(array_z[bound_start[i]] -mid_z),
                xAngstrom(array_x[bound_end[i]] -mid_x ),
                xAngstrom(array_y[bound_end[i]] -mid_y ),
                xAngstrom(array_z[bound_end[i]] -mid_z )
                );
        }
 noStroke();
  for(int i=0;i &lt; ATOM_COUNT;++i)
        {
         pushMatrix();
        translate(
                xAngstrom(array_x[i] -mid_x ),
                xAngstrom(array_y[i] -mid_y ),
                xAngstrom(array_z[i] -mid_z )
                );
        fillAtom(array_c[i]);
        sphere(zoomAtom*radiusOf(array_c[i]));
        popMatrix();
        }
  
  }
   
float xAngstrom(float x)
	{
	return x*zoom;
	}

int radiusOf(char c)
	{
	switch(c)
		{
		case 'o':case 'O': return 14;
		case 'c':case 'C': return 12;
		case 'h':case 'H': return 6;
		default: return 10;
		}
	}

void fillAtom(char c)
	{
	switch(c)
		{
		case 'o':case 'O': fill(0,0,200,alpha); break;
		case 'c':case 'C': fill(100,100,100,alpha); break;
		case 'h':case 'H': fill(200,200,200,alpha); break;
		case 'n':case 'N': fill(142,142,0,alpha); break;
		case 's':case 'S': fill(142,0,142,alpha); break;
		default: fill(142,142,142,alpha);break;
		}
	}

static float center(final float array[])
 {
   float t=0f;
   for(int i=0;i&lt;  array.length;++i)
     {
     t+=array[i];
     }
   return t/float(array.length);
 }

void keyPressed()
  {
  final float alphaShift=5;
  final float zoomShift=0.5;
  final float zoomAtomShift=0.1;
  switch(key)
        {
        case 'a':case 'A': if(alpha-alphaShift &gt;=0) this.alpha-=alphaShift; break;
        case 'z':case 'Z': if(alpha+alphaShift &lt;=255) this.alpha+=alphaShift; break;
        case 'q':case 'Q': zoom+=zoomShift; break;
        case 's':case 'S':  if(zoom-zoomShift&gt;0) zoom-=zoomShift; break;
        case 'w':case 'W': zoomAtom+=zoomAtomShift; break;
        case 'x':case 'X':  if(zoomAtom-zoomAtomShift &gt;0) zoomAtom-=zoomAtomShift; break;
        case 'd': drawBounds=!drawBounds;break;
        default:break;
        }
  }

</xsl:template>





</xsl:stylesheet>
