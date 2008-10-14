package org.lindenb.sql.schema;

import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Types;
import java.util.ArrayList;
import java.util.List;

public class Field
	{
	private String name;
	private String type;
	private String Null;
	private String Key;
	private String Default;
	private String Extra;
	
	public Field()
		{
		}
 
	public Field(ResultSet row) throws SQLException
		{
		this.name= row.getString("Field");
		this.type= row.getString("Type");
		this.Null= row.getString("Null");
		this.Key= row.getString("Key");
		this.Default= row.getString("Default");
		this.Extra=row.getString("Extra");
		}
	
	
	public String getName() {
		return name;
		}

	public void setName(String name) {
		this.name = name;
		}

	public String getDescription()
		{
		return getName();
		}

	public String getJavaName()
		{
		if(getName()==null) return null;
		String s= getName().substring(0,1).toUpperCase()+getName().substring(1);
		return s.replace('-', '_');
		}
	
	public boolean isIndexed()
		{
		return getKey().equals("MUL") || isUnique() || isPrimary();
		}
	
	public boolean isUnique()
		{
		return getKey().equals("UNI");
		}
	
	public boolean isEnum()
		{
		return getType().startsWith("enum(");
		}
	
	public boolean isSet()
		{
		return getType().startsWith("set(");
		}
	
	public List<String> getItems()
		{
		ArrayList<String> _items= new ArrayList<String>();
		return _items;
		}
	
	
	public boolean isPrimary()
		{
		return getKey().equals("PRI");
		}
	
	public boolean isAutoIncrement()
		{
		return getExtra().equals("auto_increment");
		}
	
	public boolean isNull()
		{
		return this.Null.equals("YES");
		}

	
	public int getLength()
		{
		String t=getType();
		int i= t.indexOf('(');
		if(i==-1) return -1;
		int j= t.indexOf(',',i+1);
		if(j==-1) j= t.indexOf(')',i+1);
		if(j==-1) return -1;
		return Integer.parseInt( t.substring(i+1,j));
		}
	
	public int getPrecision()
		{
		String t=getType();
		int i= t.indexOf('(');
		if(i==-1) return -1;
		i= t.indexOf(',',i+1);
		if(i==-1) return -1;
		int j= t.indexOf(')',i+1);
		if(j==-1) return -1;
		return Integer.parseInt( t.substring(i+1,j));
		}
	
	/** returns the sql type without the length/precision */
	public String getSQLType()
		{
		String t=getType();
		int i= t.indexOf('(');
		if(i==-1) return t;
		return t.substring(0,i).trim();
		}
	
	public String getKey() {
		return Key;
		}

	public String getDefault() {
		return Default;
		}
	
	/** return type as defined in the sql engine */
	public String getType()
		{
		return this.type;
		}
	
	public String getExtra() {
		return Extra;
		}
	}
