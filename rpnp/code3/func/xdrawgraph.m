function xdrawgraph(xs,yrange,method_list,field,ti,lx,ly)
    box('on');
    hold('all');

    for i= 1:length(method_list)
        plot(xs,method_list(i).(field),'marker',method_list(i).marker,...
            'color',method_list(i).color,...
            'markerfacecolor',method_list(i).markerfacecolor,...
            'displayname',method_list(i).name, ...
            'LineWidth',2,'MarkerSize',8);
    %        );
    end
    ylim(yrange);
    xlim(xs([1 end]));
    set(gca,'xtick',xs);

    title(ti,'FontSize',12,'FontName','Arial');
    xlabel(lx,'FontSize',11);
    ylabel(ly,'FontSize',11);
    legend;
end
