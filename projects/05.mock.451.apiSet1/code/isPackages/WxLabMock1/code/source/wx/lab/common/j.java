package wx.lab.common;

// -----( IS Java Code Template v1.2

import com.wm.data.*;
import com.wm.util.Values;
import com.wm.app.b2b.server.Service;
import com.wm.app.b2b.server.ServiceException;
// --- <<IS-START-IMPORTS>> ---
// --- <<IS-END-IMPORTS>> ---

public final class j

{
	// ---( internal utility methods )---

	final static j _instance = new j();

	static j _newInstance() { return new j(); }

	static j _cast(Object o) { return (j)o; }

	// ---( server methods )---




	public static final void getCrtMillis (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(getCrtMillis)>> ---
		// @sigtype java 3.5
		// [o] field:0:required crtMillis
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
		IDataUtil.put( pipelineCursor, "crtMillis", ""  + System.currentTimeMillis());
		pipelineCursor.destroy();
		// --- <<IS-END>> ---

                
	}



	public static final void probability1 (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(probability1)>> ---
		// @sigtype java 3.5
		// [i] field:0:required probability
		// [o] field:0:required bool
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
			String	probability = IDataUtil.getString( pipelineCursor, "probability" );
		pipelineCursor.destroy();
		
		float p=Float.parseFloat(probability);
		
		boolean bProbabilityMet = (Math.random() <= p);
		
		// pipeline
		IDataCursor pipelineCursor_1 = pipeline.getCursor();
		IDataUtil.put( pipelineCursor_1, "bool", ""+bProbabilityMet );
		pipelineCursor_1.destroy();
			
		// --- <<IS-END>> ---

                
	}



	public static final void randomInt (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(randomInt)>> ---
		// @sigtype java 3.5
		// [i] field:0:required min
		// [i] field:0:required max
		// [o] field:0:required randomNumber
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
			String	sMin = IDataUtil.getString( pipelineCursor, "min" );
			String	sMax = IDataUtil.getString( pipelineCursor, "max" );
		pipelineCursor.destroy();
		
		int randomNumber=0, min=0, max=0;
		
		if ( null == sMax || sMax.length()==0 ){
			throw new ServiceException("randomInt: max number Must be provided");
		}else
			if (!(null == sMin || sMin.length()==0)){
				min=Integer.parseInt(sMin);
				max=Integer.parseInt(sMax);
				if(min>max){
					int a=min;
					min=max;
					max=a;
				}
				randomNumber = (int) ((Math.random() * (max - min)) + min);
			}
		
		// pipeline
		IDataCursor pipelineCursor_1 = pipeline.getCursor();
		IDataUtil.put( pipelineCursor_1, "randomNumber", ""+randomNumber );
		pipelineCursor_1.destroy();
			
		// --- <<IS-END>> ---

                
	}



	public static final void sleep (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(sleep)>> ---
		// @sigtype java 3.5
		// [i] field:0:required millis
		IDataCursor pipelineCursor = pipeline.getCursor();
		String	sMillis = IDataUtil.getString( pipelineCursor, "millis" );
		pipelineCursor.destroy();
		
		long millis = Long.parseLong(sMillis);
		try {
			Thread.sleep(millis);
		} catch (InterruptedException e) {
			// we don't care
		}
			
		// --- <<IS-END>> ---

                
	}



	public static final void sleepRandomInt (IData pipeline)
        throws ServiceException
	{
		// --- <<IS-START(sleepRandomInt)>> ---
		// @sigtype java 3.5
		// [i] field:0:required min
		// [i] field:0:required max
		// pipeline
		IDataCursor pipelineCursor = pipeline.getCursor();
			String	sMin = IDataUtil.getString( pipelineCursor, "min" );
			String	sMax = IDataUtil.getString( pipelineCursor, "max" );
		pipelineCursor.destroy();
		
		int min=0, max=0;
		
		if ( null == sMax || sMax.length()==0 ){
			throw new ServiceException("randomInt: max number Must be provided");
		}else
			if (!(null == sMin || sMin.length()==0)){
				min=Integer.parseInt(sMin);
				max=Integer.parseInt(sMax);
				if(min>max){
					int a=min;
					min=max;
					max=a;
				}
				try {
					Thread.sleep((long) ((Math.random() * (max - min)) + min));
				} catch (InterruptedException e) {
					// we don't care
				}
			}
		
			
		// --- <<IS-END>> ---

                
	}
}

