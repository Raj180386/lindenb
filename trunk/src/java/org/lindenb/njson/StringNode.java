package org.lindenb.njson;

import org.lindenb.util.C;

public class  StringNode extends TerminalNode
	implements Comparable<StringNode>
	{
	private String value;
	public StringNode(String value)
		{
		this.value=value;
		}
	@Override
	public Type getType()
		{
		return Type.STRING;
		}
	
	public String getValue()
		{
		return value;
		}
	
	@Override
	public void print(java.io.Writer out) throws java.io.IOException
		{
		out.write('\'');
		out.write(C.escape(this.getValue()));
		out.write('\'');
		}
	@Override
	public int hashCode()
		{
		return getValue().hashCode();
		}
	@Override
	public boolean equals(Object o)
		{
		if(o==this) return true;
		if(o==null || !(o instanceof StringNode)) return false;
		return StringNode.class.cast(o).getValue().equals(getValue());
		}
	
	public boolean equalsIgnoreCase(StringNode o)
		{
		if(o==this) return true;
		if(o==null ) return false;
		return getValue().equalsIgnoreCase(o.getValue());
		}
	@Override
	public Object clone()
		{
		return new StringNode(getValue());
		}
	@Override
	public int compareTo(StringNode o)
		{
		return getValue().compareTo(o.getValue());
		}
	
	public int compareToIgnoreCase(StringNode o)
		{
		return getValue().compareToIgnoreCase(o.getValue());
		}
	
	@Override
	public String toString()	
		{
		return String.valueOf(getValue());
		}
	}