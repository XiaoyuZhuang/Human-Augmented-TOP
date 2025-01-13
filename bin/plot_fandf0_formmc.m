yy(Loop)=f0val;
yyv(Loop)=A1/(DW*DH);
if mod(Loop,10)==1||Loop>maxiter-5
    figure(3);
    xx=1:length(yy);
    [ax, h1, h2] = plotyy(xx, yy, xx, yyv);
    ylabel(ax(1), 'Object', 'FontWeight', 'bold', 'FontSize', 12);
    ylabel(ax(2), 'Volume', 'FontWeight', 'bold', 'FontSize', 12);
    xlabel('Loop', 'FontWeight', 'bold', 'FontSize', 12);
    xlabel('Loop');
    set(h1, 'LineStyle', '-','LineWidth', 2);
    set(h2, 'LineStyle', '--','LineWidth', 2);
    legend('Object', 'Volume');
    set(ax, 'FontWeight', 'bold', 'FontSize', 12);drawnow;
end
