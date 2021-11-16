import os
from pum.core.deltapy import DeltaPy

class RecreateViews(DeltaPy):

    def run(self):
        self.write_message('Recreating sige views')

        rewrite_views = os.path.join(self.delta_dir, '..', 'rewrite_views.sh')
        cmd = 'PGSERVICE={} SRID=2056 {}'.format(self.pg_service, rewrite_views)
        self.write_message(cmd)
        os.system(cmd)

        self.write_message('Recreating sige views: done')
