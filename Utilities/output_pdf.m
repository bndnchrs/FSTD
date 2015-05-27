function output_pdf(fig_handle,outname,Pap_Size,Position)

f = fig_handle; 

set(f,'PaperUnits','inches')
set(f,'PaperSize',Pap_Size)
set(f,'PaperPosition',Position); 
saveas(f,outname); 


end