yy(Loop)=f0val;
yyv(Loop)=fval+volfrac;
if mod(Loop,10)==0
    xx=1:length(yy);
    subplot(2,1,2)
    [ax, h1, h2] = plotyy(xx, yy, xx, yyv);
    ylabel(ax(1), 'Compliance');
    ylabel(ax(2), 'Volume');
    xlabel('Loop');
    set(h1, 'LineStyle', '-');
    set(h2, 'LineStyle', '--');
    legend('Compliance', 'Volume');
    drawnow;
end
